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

class PersonnelViewModel: ObservableObject {

    @Published var personnels: [Personnel] = []

    func load(folder: String) {
        PersonnelService.shared.fetchPersonnel(folder: folder) { [weak self] data in
            self?.personnels = data
        }
    }
}
