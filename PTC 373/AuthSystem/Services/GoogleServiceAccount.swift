import Foundation

// 1. Définition de la structure principale
struct GDriveFile: Codable {
    let id: String
    let name: String
    let mimeType: String
    let size: String?
    let createdTime: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        mimeType = try container.decode(String.self, forKey: .mimeType)
        size = try container.decodeIfPresent(String.self, forKey: .size)
        createdTime = try container.decode(String.self, forKey: .createdTime)
    }
}

// 2. Extension pour Identifiable et propriétés calculées
extension GDriveFile: Identifiable {
    var thumbnailURL: URL? {
        if mimeType.hasPrefix("image/") {
            return URL(string: "https://drive.google.com/thumbnail?id=\(id)&sz=w300")
        }
        return nil
    }

    var isImage: Bool {
        mimeType.hasPrefix("image/")
    }
}

// 3. Structure de réponse
struct GDriveFilesResponse: Codable {
    let files: [GDriveFile]
}

// 4. Service Google Drive
class GoogleDriveService {
    static let shared = GoogleDriveService()
    private let folderID = "1ZyL6SY0C3YRKXlyiQiFyHoDTgbSFdFsz"

    func fetchFiles(completion: @escaping ([GDriveFile]?) -> Void) {
        let apiKey = "AIzaSyCJIOrmgbkI62z9MYCaeV8JQ0S8JjFi0vw"
        let urlString = "https://www.googleapis.com/drive/v3/files?q='\(folderID)'+in+parents&key=\(apiKey)&fields=files(id,name,mimeType,size,createdTime)"

        guard let url = URL(string: urlString) else {
            print("❌ URL invalide")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur réseau: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ Aucune donnée reçue")
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(GDriveFilesResponse.self, from: data)
                print("✅ Succès: \(response.files.count) fichiers trouvés")
                completion(response.files)
            } catch {
                print("❌ Erreur parsing: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON reçu: \(jsonString)")
                }
                completion(nil)
            }
        }.resume()
    }
}
