import Foundation
import SwiftUI

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var isLoading = true
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false

    private let userKey = "currentUser"
    private let userIdKey = "userId"

    init() {
        autoLogin()
    }

    // MARK: - LOGIN
    func login(email: String, password: String) {
        errorMessage = nil

        let url = URL(string: "https://rievjzhjryfpkqmzyqde.supabase.co/auth/v1/token?grant_type=password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("sb_publishable_cHoSokLdPqML60iTKmWkkA_6Xx3gGxc", forHTTPHeaderField: "apikey")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Pas de réponse serveur"
                }
                return
            }

            // ✅ erreur Supabase
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["error_code"] != nil {

                DispatchQueue.main.async {
                    self.errorMessage = "Email ou mot de passe incorrect"
                    self.isAuthenticated = false
                    self.isLoggedIn = false
                    self.currentUser = nil
                }
                return
            }

            // ✅ LOGIN OK
            UserService.shared.refreshUsers(force: true) { success in
                if success {

                    if let user = UserService.shared.getUser(byEmail: email) {

                        DispatchQueue.main.async {
                            self.currentUser = user
                            self.isAuthenticated = true
                            self.isLoggedIn = true

                            self.saveUser()
                            UserDefaults.standard.set(user.id, forKey: self.userIdKey)

                            print("✅ Utilisateur chargé :", user.username)
                        }

                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Utilisateur introuvable"
                        }
                    }

                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Erreur chargement utilisateurs"
                    }
                }
            }

        }.resume()
    }

    // MARK: - AUTO LOGIN
    func autoLogin() {
        isLoading = true

        guard let userId = UserDefaults.standard.string(forKey: userIdKey) else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return
        }

        UserService.shared.refreshUsers(force: true) { success in
            DispatchQueue.main.async {

                if success,
                   let user = UserService.shared.getUser(byId: userId) {

                    self.currentUser = user
                    self.isLoggedIn = true
                    self.isAuthenticated = true
                    self.saveUser()

                } else {
                    self.logout()
                }

                self.isLoading = false // ✅ FINI
            }
        }
    }


    // MARK: - LOGOUT
    func logout() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isLoggedIn = false
            self.isAuthenticated = false

            self.clearUser()
            UserDefaults.standard.removeObject(forKey: self.userIdKey)
        }
    }

    // MARK: - PERSISTENCE
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    // MARK: - UTILS
    func getUserFullName() -> String {
        guard let user = currentUser else { return "" }
        return "\(user.prenom) \(user.nom)"
    }

    func getUserLevelsDescription() -> String {
        guard let levels = currentUser?.levels else { return "" }
        return levels.map { $0.displayName }.joined(separator: ", ")
    }

    func hasLevel(_ level: UserLevel) -> Bool {
        currentUser?.levels.contains(level) ?? false
    }

    func hasAnyLevel(_ levels: [UserLevel]) -> Bool {
        guard let userLevels = currentUser?.levels else { return false }
        return !Set(userLevels).intersection(Set(levels)).isEmpty
    }

    func hasAllLevels(_ levels: [UserLevel]) -> Bool {
        guard let userLevels = currentUser?.levels else { return false }
        return Set(userLevels).isSuperset(of: Set(levels))
    }
}
