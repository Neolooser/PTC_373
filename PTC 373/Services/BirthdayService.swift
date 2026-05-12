import Foundation

class BirthdayService {
    private let userService: UserService
    private let calendar = Calendar.current

    // Initialiseur avec injection de dépendance
    init(userService: UserService = UserService.shared) {
        self.userService = userService
    }

    // MARK: - Public Methods

    /// Récupère les anniversaires du jour
    func getTodaysBirthdays() -> [User] {
        let allUsers = userService.getAllUsers()
        print("🔍 Nombre total d'utilisateurs: \(allUsers.count)")

        let today = Date()
        let todayComponents = calendar.dateComponents([.day, .month], from: today)

        return allUsers.filter { user in
            // Vérification du type d'utilisateur
            guard user.shouldAppearInBirthdays else {
                print("🚫 Exclu: \(user.prenom) \(user.nom) (type: \(user.type.rawValue))")
                return false
            }

            // ✅ unwrap birthdate
            guard let birthdate = user.birthdate else {
                print("⚠️ Pas de date de naissance pour \(user.prenom) \(user.nom)")
                return false
            }

            // Comparaison des dates
            let birthComponents = calendar.dateComponents([.day, .month], from: birthdate)

            let isBirthday = birthComponents.day == todayComponents.day &&
                             birthComponents.month == todayComponents.month

            if isBirthday {
                print("🎉 Anniversaire aujourd'hui: \(user.prenom) \(user.nom) - \(birthdate)")
            }

            return isBirthday
        }
    }

    /// Rafraîchit les données des utilisateurs
    func refreshBirthdays(completion: @escaping (Bool) -> Void) {
        userService.refreshUsers { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}

// Pour modif
