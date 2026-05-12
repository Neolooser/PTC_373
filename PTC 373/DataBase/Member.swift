import Foundation

struct Member: Identifiable, Codable {
    let id = UUID()
    let name: String
    let birthdate: String
    let role: String?

    enum CodingKeys: String, CodingKey {
        case name, birthdate, role
    }
}
