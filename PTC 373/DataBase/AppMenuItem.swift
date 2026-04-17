import SwiftUI

struct AppMenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: AnyView?
    let action: (() -> Void)?

    // Constructeur pour les éléments avec destination
    init<Destination: View>(title: String, icon: String = "", destination: Destination) {
        self.title = title
        self.icon = icon
        self.destination = AnyView(destination)
        self.action = nil
    }

    // Constructeur pour les éléments avec action (comme Déconnexion)
    init(title: String, icon: String = "", action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.destination = nil
        self.action = action
    }

    // Implémentation de Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Implémentation de Equatable
    static func == (lhs: AppMenuItem, rhs: AppMenuItem) -> Bool {
        lhs.id == rhs.id
    }
}
