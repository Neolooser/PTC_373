import Foundation

class PersonnelViewModel: ObservableObject {

    @Published var personnels: [Personnel] = []

    func load(folder: String) {
        PersonnelService.shared.fetchPersonnel(folder: folder) { [weak self] data in
            self?.personnels = data
        }
    }
}
