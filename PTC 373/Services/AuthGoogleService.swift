// Services/AuthService.swift
import Foundation
import Security

struct AuthGoogleService {
    let email: String
    let privateKey: String

    // Charger depuis Google Drive
    static func loadFromGoogleDrive() -> GoogleServiceAccount? {
        let fileID = "1kE-bC3P_EDUXwufN1MIA5kiLakD_B0PD" // Ex: "1KByck94_UDEAApV1JDkUwERCmCyIHAk4"

        // 2. Ajouter un timestamp pour éviter le cache
        let timestamp = Date().timeIntervalSince1970
        let urlString = "https://drive.google.com/uc?export=download&id=\(fileID)&t=\(timestamp)"

        // 3. Créer l'URL
        guard let url = URL(string: urlString) else {
            print("❌ URL invalide")
            return nil
        }

        // 4. Télécharger le fichier (synchroniquement)
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            print("❌ Échec du téléchargement: \(error.localizedDescription)")
            return nil
        }

        // 5. Parser le JSON
        let json: [String: Any]
        do {
            json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
        } catch {
            print("❌ Fichier JSON invalide: \(error.localizedDescription)")
            return nil
        }

        // 6. Extraire les champs requis
        guard let email = json["client_email"] as? String,
              let privateKey = json["private_key"] as? String else {
            print("❌ Champs manquants dans le JSON (client_email ou private_key)")
            return nil
        }

        // 7. Vérifier la validité de la clé privée
        if !privateKey.contains("-----BEGIN PRIVATE KEY-----") {
            print("❌ Clé privée invalide (format incorrect)")
            return nil
        }

        return GoogleServiceAccount(email: email, privateKey: privateKey)
    }

    // Générer un JWT (méthode existante)
    func generateJWT() -> String? {
        // Ton code existant pour générer le JWT
        // ...
        return nil // Remplace par ton implémentation réelle
    }
}

class AuthGoogleService {
    static let shared = AuthGoogleService()
    private let serviceAccount: GoogleServiceAccount

    init() {
        // Charger depuis Google Drive au lieu du bundle
        guard let account = GoogleServiceAccount.loadFromGoogleDrive() else {
            fatalError("❌ Impossible de charger le fichier depuis Google Drive")
        }
        self.serviceAccount = account
    }

    // Obtenir un token d'accès
    func getAccessToken(completion: @escaping (String?) -> Void) {
        // 1. Générer le JWT
        guard let jwt = serviceAccount.generateJWT() else {
            print("❌ Échec de la génération du JWT")
            completion(nil)
            return
        }

        // 2. Échanger le JWT contre un token
        let url = URL(string: "https://oauth2.googleapis.com/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(jwt)"
        request.httpBody = body.data(using: .utf8)

        // 3. Exécuter la requête
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Vérifier les erreurs
            if let error = error {
                print("❌ Erreur réseau: \(error.localizedDescription)")
                completion(nil)
                return
            }

            // Vérifier la réponse HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Réponse HTTP invalide")
                completion(nil)
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ Erreur HTTP: \(httpResponse.statusCode)")
                if let data = data {
                    print("Réponse: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                completion(nil)
                return
            }

            // Vérifier les données
            guard let data = data else {
                print("❌ Aucune donnée reçue")
                completion(nil)
                return
            }

            // 4. Parser la réponse
            do {
                let response = try JSONDecoder().decode([String: String].self, from: data)
                if let token = response["access_token"] {
                    print("✅ Token obtenu avec succès")
                    completion(token)
                } else {
                    print("❌ Token manquant dans la réponse")
                    completion(nil)
                }
            } catch {
                print("❌ Échec du parsing: \(error.localizedDescription)")
                print("Données reçues: \(String(data: data, encoding: .utf8) ?? "nil")")
                completion(nil)
            }
        }.resume()
    }
}


func createSecKey(from privateKey: String) -> SecKey? {
    // 1. Décoder directement la clé en base64 (sans nettoyage supplémentaire)
    guard let keyData = Data(base64Encoded: privateKey) else {
        print("❌ Échec du décodage base64 de la clé privée")
        return nil
    }

    // 2. Vérifier la taille de la clé (doit être 2048 ou 4096 bits)
    let keySize = keyData.count * 8
    print("🔑 Taille de la clé : \(keySize) bits")

    // 3. Définir les attributs de la clé
    let attributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
        kSecAttrKeySizeInBits as String: keySize, // Utilise la taille réelle de la clé
        kSecReturnPersistentRef as String: true
    ]

    // 4. Créer SecKey
    var error: Unmanaged<CFError>?
    guard let secKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
        print("❌ Échec de la création de SecKey: \(error!.takeRetainedValue())")
        return nil
    }

    print("✅ SecKey créée avec succès !")
    return secKey
}
