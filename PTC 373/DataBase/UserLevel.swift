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
