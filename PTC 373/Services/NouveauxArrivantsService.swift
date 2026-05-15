import UIKit
import Foundation

class NouveauxArrivantsService {

    static let shared = NouveauxArrivantsService()

    private let baseURL = "https://rievjzhjryfpkqmzyqde.supabase.co/storage/v1/object/public/New/"
    private let listURL = "https://rievjzhjryfpkqmzyqde.supabase.co/storage/v1/object/list/New"
    private let tableURL = "https://rievjzhjryfpkqmzyqde.supabase.co/rest/v1/New"

    private let apiKey = "sb_publishable_cHoSokLdPqML60iTKmWkkA_6Xx3gGxc"

    // ✅ CACHE IMAGE
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let documentsURL: URL

    private init() {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsPath.appendingPathComponent("NouveauxArrivantsImages")
        try? fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true)
    }

    // ✅ FETCH COMPLET
    func fetchNouveauxArrivants(completion: @escaping ([NouveauxArrivant]) -> Void) {

        fetchTextes { [weak self] textes in
            guard let self = self else { return }

            guard let url = URL(string: self.listURL) else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(self.apiKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")

            let body: [String: Any] = [
                "prefix": ""
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, _, error in

                if let error = error {
                    print("Erreur fetch images:", error.localizedDescription)
                    DispatchQueue.main.async { completion([]) }
                    return
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                    DispatchQueue.main.async { completion([]) }
                    return
                }

                let formatter = ISO8601DateFormatter()
                var result: [NouveauxArrivant] = []

                for item in json {

                    guard let name = item["name"] as? String else { continue }
                    if name.hasPrefix(".") { continue }

                    let updated = item["updated_at"] as? String
                    let date = updated.flatMap { formatter.date(from: $0) } ?? Date()

                    let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
                    let imageURL = "\(self.baseURL)\(encodedName)"

                    let data = textes[name]
                    let texte = data?.texte ?? "Aucune description"
                    let displayName = data?.displayName ?? name

                    result.append(
                        NouveauxArrivant(
                            id: UUID(),
                            name: name,
                            imagePath: imageURL,
                            texte: texte,
                            displayName: displayName,
                            lastModified: date
                        )
                    )
                }

                result.sort { $0.lastModified > $1.lastModified }

                DispatchQueue.main.async {
                    completion(result)
                }

            }.resume()
        }
    }

    // ✅ FETCH IMAGE AVEC CACHE TOTAL
    func fetchImage(path: String, lastModified: Date, completion: @escaping (UIImage?) -> Void) {

        let key = NSString(string: path)

        // ✅ 1. CACHE MÉMOIRE
        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }

        let fileName = URL(string: path)?.lastPathComponent ?? ""
        let fileURL = documentsURL.appendingPathComponent(fileName)

        // ✅ 2. CACHE DISQUE + CHECK DATE
        if fileManager.fileExists(atPath: fileURL.path) {

            if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
               let fileDate = attributes[.modificationDate] as? Date {

                if fileDate >= lastModified {
                    if let image = UIImage(contentsOfFile: fileURL.path) {
                        cache.setObject(image, forKey: key)
                        completion(image)
                        return
                    }
                }
            }
        }

        // ✅ 3. DOWNLOAD (SEULEMENT SI NÉCESSAIRE)
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }

            if let data = data, let image = UIImage(data: data) {

                // Sauvegarde disque
                try? data.write(to: fileURL)

                // Met à jour la date fichier
                try? self.fileManager.setAttributes(
                    [.modificationDate: lastModified],
                    ofItemAtPath: fileURL.path
                )

                self.cache.setObject(image, forKey: key)

                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }

        }.resume()
    }

    // ✅ FETCH TEXTES
    private func fetchTextes(completion: @escaping ([String: (texte: String, displayName: String)]) -> Void) {

        guard let url = URL(string: tableURL) else {
            completion([:])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Erreur fetch textes:", error.localizedDescription)
                completion([:])
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                completion([:])
                return
            }

            var result: [String: (texte: String, displayName: String)] = [:]

            for item in json {

                if let imageName = item["image_name"] as? String,
                   let texte = item["Texte"] as? String,
                   let displayName = item["Name"] as? String {

                    result[imageName] = (texte, displayName)
                }
            }

            completion(result)

        }.resume()
    }
}

// ✅ MODEL
struct NouveauxArrivant: Identifiable, Codable {
    let id: UUID
    let name: String
    let imagePath: String
    let texte: String
    let displayName: String
    let lastModified: Date
}
