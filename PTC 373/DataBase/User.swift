import Foundation

enum UserLevel: String, Codable, CaseIterable {
    case admin = "admin"
    case chefDeCentre = "chef_de_centre"
    case operateur = "operateur"
    case chefDeService = "chef_de_service"
    case gdj = "gdj"
    case membre = "membre"
    case infirmier = "infirmier"

    var displayName: String {
        switch self {
        case .admin: return "Administrateur"
        case .chefDeCentre: return "Chef de Centre"
        case .operateur: return "Opérateur"
        case .chefDeService: return "Chef de Service"
        case .gdj: return "GDJ"
        case .membre: return "Membre"
        case .infirmier: return "Infirmier"
        }
    }
}

struct User: Codable, Identifiable {
    let id: String
    let username: String
    var levels: [UserLevel]
    let type: UserType
    let nom: String
    let prenom: String
    let name: String
    let birthdate: Date?
    let mail: String?
    let telephone: String?

    // ✅ MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, username, levels, type, nom, prenom, name, birthdate, mail, telephone
    }

    // ✅ MARK: - INIT JSON (Supabase)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        type = try container.decode(UserType.self, forKey: .type)
        nom = try container.decode(String.self, forKey: .nom)
        prenom = try container.decode(String.self, forKey: .prenom)
        name = try container.decode(String.self, forKey: .name)
        mail = try container.decodeIfPresent(String.self, forKey: .mail)
        telephone = try container.decodeIfPresent(String.self, forKey: .telephone)

        // ✅ levels: "admin" ou "admin,operateur"
        let levelString = try container.decode(String.self, forKey: .levels)
        self.levels = levelString
            .split(separator: ",")
            .compactMap { UserLevel(rawValue: String($0)) }

        // ✅ birthdate
        if let dateString = try container.decodeIfPresent(String.self, forKey: .birthdate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "fr_FR")
            self.birthdate = formatter.date(from: dateString)
        } else {
            self.birthdate = nil
        }
    }

    // ✅ MARK: - INIT MANUEL (IMPORTANT pour AuthService)
    init(
        id: String,
        username: String,
        levels: [UserLevel],
        type: UserType,
        nom: String,
        prenom: String,
        name: String,
        birthdate: Date?,
        mail: String?,
        telephone: String?
    ) {
        self.id = id
        self.username = username
        self.levels = levels
        self.type = type
        self.nom = nom
        self.prenom = prenom
        self.name = name
        self.birthdate = birthdate
        self.mail = mail
        self.telephone = telephone
    }

    // ✅ MARK: - UserType
    enum UserType: String, Codable {
        case normal
        case fake
        case generic
    }

    // ✅ MARK: - Helpers

    func hasLevel(_ level: UserLevel) -> Bool {
        levels.contains(level)
    }

    func hasAnyLevel(_ levels: [UserLevel]) -> Bool {
        !Set(self.levels).intersection(Set(levels)).isEmpty
    }

    func hasAllLevels(_ levels: [UserLevel]) -> Bool {
        Set(self.levels).isSuperset(of: Set(levels))
    }

    var shouldAppearInBirthdays: Bool {
        type == .normal
    }

    var shouldAppearInDirectory: Bool {
        type != .fake
    }

    var age: Int {
        guard let birthdate = birthdate else { return 0 }
        let calendar = Calendar.current
        let now = Date()
        return calendar.dateComponents([.year], from: birthdate, to: now).year ?? 0
    }
}
