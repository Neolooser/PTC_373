import UIKit
import Foundation

class PersonnelService {

    static let shared = PersonnelService()

    private let baseURL = "https://rievjzhjryfpkqmzyqde.supabase.co/storage/v1/object/public/Trombinoscope/"
    private let listURL = "https://rievjzhjryfpkqmzyqde.supabase.co/storage/v1/object/list/Trombinoscope"

    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let documentsURL: URL

    // Clés pour le cache
    private enum CacheKeys {
        static let personnelMetadata = "PersonnelMetadata"
        static let imageCache = "ImageCache"
    }

    init() {
        // Initialiser le dossier de cache
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsPath.appendingPathComponent("PersonnelImages")
        try? fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true)
    }

    // MARK: - Fetch list avec vérification des modifications
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

        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self else { return }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            let formatter = ISO8601DateFormatter()
            var personnels = [Personnel]()

            // Charger le cache local des métadonnées
            let cachedPersonnels = self.loadCachedPersonnels(folder: cleanFolder)

            for item in json {
                guard let name = item["name"] as? String else { continue }
                if name.hasPrefix(".") { continue }

                let updated = item["updated_at"] as? String
                let date = updated.flatMap { formatter.date(from: $0) } ?? Date()

                let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
                let imageURL = "\(self.baseURL)\(cleanFolder)\(encodedName)"

                // Vérifier si l'image existe déjà en local
                if let cached = cachedPersonnels.first(where: { $0.name == name }) {
                    // Comparer les dates - si Supabase est plus récent, on met à jour
                    if date > cached.lastModified {
                        personnels.append(Personnel(name: name, imagePath: imageURL, lastModified: date))
                    } else {
                        // Garder l'ancien personnel avec la nouvelle date si elle est plus récente
                        personnels.append(Personnel(name: name, imagePath: cached.imagePath, lastModified: cached.lastModified))
                    }
                } else {
                    // Nouvelle image
                    personnels.append(Personnel(name: name, imagePath: imageURL, lastModified: date))
                }
            }

            // Sauvegarder le cache des métadonnées
            self.savePersonnels(personnels, folder: cleanFolder)

            DispatchQueue.main.async {
                completion(personnels)
            }

        }.resume()
    }

    // MARK: - Cache des métadonnées
    private func savePersonnels(_ personnels: [Personnel], folder: String) {
        let key = "\(CacheKeys.personnelMetadata)_\(folder)"
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(personnels) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadCachedPersonnels(folder: String) -> [Personnel] {
        let key = "\(CacheKeys.personnelMetadata)_\(folder)"
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Personnel].self, from: data) {
                return decoded
            }
        }
        return []
    }

    // MARK: - Fetch image avec cache mémoire et disque
    func fetchImage(path: String, completion: @escaping (UIImage?) -> Void) {
        let key = NSString(string: path)

        // 1. Vérifier le cache mémoire
        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }

        // 2. Vérifier le cache disque
        if let image = loadImageFromDisk(path: path) {
            cache.setObject(image, forKey: key)
            completion(image)
            return
        }

        // 3. Télécharger si pas en cache
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? path
        guard let url = URL(string: encodedPath) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("Erreur de téléchargement: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            // Sauvegarder en cache disque
            self.saveImageToDisk(image, path: path)

            // Sauvegarder en cache mémoire
            self.cache.setObject(image, forKey: key)

            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()
    }

    // MARK: - Gestion du cache disque
    private func saveImageToDisk(_ image: UIImage, path: String) {
        let fileName = URL(string: path)?.lastPathComponent ?? "image_\(Date().timeIntervalSince1970).jpg"
        let fileURL = documentsURL.appendingPathComponent(fileName)

        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
    }

    private func loadImageFromDisk(path: String) -> UIImage? {
        let fileName = URL(string: path)?.lastPathComponent ?? ""
        let fileURL = documentsURL.appendingPathComponent(fileName)

        if fileManager.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }
        return nil
    }

    // MARK: - Nettoyage du cache
    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: documentsURL)
        try? fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true)
        UserDefaults.standard.removeObject(forKey: CacheKeys.personnelMetadata)
    }
}

struct Personnel: Identifiable, Codable {
    var id = UUID()
    let name: String
    let imagePath: String
    let lastModified: Date

    var displayName: String {
        return name
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}

class PersonnelViewModel: ObservableObject {

    @Published var personnels: [Personnel] = []

    func load(folder: String) {
        PersonnelService.shared.fetchPersonnel(folder: folder) { [weak self] data in
            self?.personnels = data
        }
    }
}
