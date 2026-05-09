import Foundation

struct Personnel: Identifiable, Codable {
    let id = UUID()
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
