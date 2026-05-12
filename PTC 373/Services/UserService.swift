import Foundation

class UserService {

    // ✅ Singleton
    static let shared = UserService()
    private init() {}

    // ✅ Données
    private var users: [User] = []
    private var hasLoaded = false

    // ✅ Accès public
    func getAllUsers() -> [User] {
        return users
    }
    // ✅ Refresh depuis Supabase
    func refreshUsers(force: Bool = false, completion: @escaping (Bool) -> Void) {

        // ✅ Cache uniquement si données EXISTENT vraiment
        if hasLoaded && !force && !users.isEmpty {
            print("✅ Users déjà chargés (cache)")
            completion(true)
            return
        }

        print("🌐 Chargement depuis Supabase...")

        guard let url = URL(string: "https://rievjzhjryfpkqmzyqde.supabase.co/rest/v1/users?select=*") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // ✅ Headers Supabase
        let apiKey = "sb_publishable_cHoSokLdPqML60iTKmWkkA_6Xx3gGxc"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Erreur réseau :", error)
                DispatchQueue.main.async { completion(false) }
                return
            }

            guard let data = data else {
                print("❌ Pas de données")
                DispatchQueue.main.async { completion(false) }
                return
            }

            // ✅ DEBUG JSON
            if let json = String(data: data, encoding: .utf8) {
                print("📦 JSON reçu :\n\(json)")
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let decodedUsers = try decoder.decode([User].self, from: data)

                DispatchQueue.main.async {
                    self.users = decodedUsers
                    self.hasLoaded = true

                    print("✅ \(decodedUsers.count) users chargés depuis Supabase")
                    completion(true)
                }

            } catch {
                print("❌ Erreur décodage :", error)
                DispatchQueue.main.async { completion(false) }
            }

        }.resume()
    }

    // ✅ Récupération utilisateur
    func getUser(byUsername username: String) -> User? {
        return users.first {
            ($0.username).lowercased() == username.lowercased()
        }
    }
    func getUser(byEmail email: String) -> User? {
        return users.first {
            ($0.mail ?? "").lowercased() == email.lowercased()
        }
    }
    func getUser(byId id: String) -> User? {
        return users.first {
            $0.id == id
        }
    }

}
