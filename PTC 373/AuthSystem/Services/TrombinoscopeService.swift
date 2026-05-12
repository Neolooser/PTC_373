import UIKit

class PersonnelService {

    static let shared = PersonnelService()

    private let baseURL = "https://rievjzhjryfpkqmzyqde.supabase.co/storage/v1/object/public/Trombinoscope/"
    private let listURL = "https://rievjzhjryfpkqmzyqde.supabase.co/storage/v1/object/list/Trombinoscope"

    private let cache = NSCache<NSString, UIImage>()

    // MARK: - Fetch list
    func fetchPersonnel(folder: String, completion: @escaping ([Personnel]) -> Void) {

        guard let url = URL(string: listURL) else {
            DispatchQueue.main.async { completion([]) }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let apiKey = "sb_publishable_cHoSokLdPqML60iTKmWkkA_6Xx3gGxc"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let cleanFolder = folder.hasSuffix("/") ? folder : folder + "/"

        let body: [String: Any] = [
            "prefix": cleanFolder
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async { completion([]) }
            return
        }

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, _ in

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            let formatter = ISO8601DateFormatter()

            let personnels = json.compactMap { item -> Personnel? in
                guard let name = item["name"] as? String else { return nil }

                // ✅ Filtre fichiers inutiles (IMPORTANT)
                if name.hasPrefix(".") { return nil }

                let updated = item["updated_at"] as? String
                let date = updated.flatMap { formatter.date(from: $0) } ?? Date()

                let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name

                let imageURL = "\(self.baseURL)\(cleanFolder)\(encodedName)"

                return Personnel(
                    name: name,
                    imagePath: imageURL,
                    lastModified: date
                )
            }

            DispatchQueue.main.async {
                completion(personnels)
            }

        }.resume()
    }

    // MARK: - Fetch image avec cache
    func fetchImage(path: String, completion: @escaping (UIImage?) -> Void) {

        let key = NSString(string: path)

        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }

        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? path

        guard let url = URL(string: encodedPath) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in

            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self.cache.setObject(image, forKey: key)

            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()
    }
}
