import Foundation

// MARK: - Modèles pour les fichiers Google Drive
struct GDriveFile: Codable {
    let id: String
    let name: String
    let mimeType: String
    let size: String?
    let createdTime: String
}

struct GDriveFilesResponse: Codable {
    let files: [GDriveFile]
}

// MARK: - Compte de service Google
struct GoogleServiceAccount: Codable {
    let clientEmail: String
    let privateKey: String
    let privateKeyID: String
    let projectID: String?

    static func loadFromGoogleDrive(completion: @escaping (Result<GoogleServiceAccount, Error>) -> Void) {
        let fileID = "1kE-bC3P_EDUXwufN1MIA5kiLakD_B0PD"
        let urlString = "https://drive.google.com/uc?export=download&id=1kE-bC3P_EDUXwufN1MIA5kiLakD_B0PD"

        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.cannotDecodeContentData)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]

                guard let email = json["client_email"] as? String,
                      let privateKey = json["private_key"] as? String,
                      let privateKeyID = json["private_key_id"] as? String else {
                    completion(.failure(URLError(.cannotParseResponse)))
                    return
                }

                let account = GoogleServiceAccount(
                    clientEmail: email,
                    privateKey: privateKey,
                    privateKeyID: privateKeyID,
                    projectID: json["project_id"] as? String
                )
                completion(.success(account))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func generateJWT() -> String? {
        // Header
        let header = ["alg": "RS256", "typ": "JWT"]
        guard let headerData = try? JSONSerialization.data(withJSONObject: header) else {
            print("❌ Erreur de sérialisation du header")
            return nil
        }
        let headerBase64 = headerData.base64URLEncoded()

        // Payload (Claims)
        let now = Int(Date().timeIntervalSince1970)
        let claims: [String: Any] = [
            "iss": clientEmail,
            "scope": "https://www.googleapis.com/auth/drive.readonly",
            "aud": "https://oauth2.googleapis.com/token",
            "exp": now + 3600,
            "iat": now
        ]
        guard let claimsData = try? JSONSerialization.data(withJSONObject: claims) else {
            print("❌ Erreur de sérialisation des claims")
            return nil
        }
        let claimsBase64 = claimsData.base64URLEncoded()

        // Signature (placeholder - à remplacer par une vraie signature RSA en production)
        let signatureInput = "\(headerBase64).\(claimsBase64)"
        let signature = "signature_placeholder" // À remplacer par une vraie signature

        return "\(signatureInput).\(signature)"
    }
}

// MARK: - Service principal
class GoogleDriveService {
    static let shared = GoogleDriveService()
    private var serviceAccount: GoogleServiceAccount?
    private var accessToken: String?

    private init() {
        loadServiceAccount()
    }

    private func loadServiceAccount() {
        GoogleServiceAccount.loadFromGoogleDrive { [weak self] result in
            switch result {
            case .success(let account):
                self?.serviceAccount = account
                print("✅ Compte de service chargé avec succès")
            case .failure(let error):
                print("❌ Erreur de chargement du compte: \(error.localizedDescription)")
            }
        }
    }

    // Récupère un token d'accès OAuth2
    private func getAccessToken(completion: @escaping (String?) -> Void) {
        guard let serviceAccount = serviceAccount else {
            print("❌ Compte de service non chargé")
            completion(nil)
            return
        }

        guard let jwt = serviceAccount.generateJWT() else {
            completion(nil)
            return
        }

        let url = URL(string: "https://oauth2.googleapis.com/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(jwt)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ Erreur lors de la requête OAuth: \(error?.localizedDescription ?? "Inconnue")")
                completion(nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let accessToken = json?["access_token"] as? String
                completion(accessToken)
            } catch {
                print("❌ Erreur de parsing du token: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    // Récupère la liste des fichiers dans Google Drive
    func fetchFiles(completion: @escaping ([GDriveFile]?) -> Void) {
        getAccessToken { [weak self] token in
            guard let token = token else {
                completion(nil)
                return
            }

            let url = URL(string: "https://www.googleapis.com/drive/v3/files")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("❌ Erreur lors de la récupération des fichiers: \(error?.localizedDescription ?? "Inconnue")")
                    completion(nil)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(GDriveFilesResponse.self, from: data)
                    completion(response.files)
                } catch {
                    print("❌ Erreur de parsing des fichiers: \(error.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }
    }
}

// MARK: - Extension pour le base64 URL-safe
extension Data {
    func base64URLEncoded() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

extension Dictionary {
    func base64URLEncoded() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            return data.base64URLEncoded()
        } catch {
            print("❌ Erreur de conversion en base64: \(error)")
            return ""
        }
    }
}
