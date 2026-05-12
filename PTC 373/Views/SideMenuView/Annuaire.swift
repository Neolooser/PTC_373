import SwiftUI

// MARK: - Main Annuaire View
struct Annuaire: View {
    @State private var searchText = ""
    @State private var users: [User] = []
    let service = UserService.shared
    

    private var filteredUsers: [User] {
        let query = searchText.lowercased()

        let result: [User]

        if query.isEmpty {
            result = users
        } else {
            result = users.filter { user in
                user.nom.lowercased().contains(query) ||
                user.prenom.lowercased().contains(query) ||
                (user.telephone?.lowercased().contains(query) ?? false) ||
                (user.mail?.lowercased().contains(query) ?? false)
            }
        }

        return result.sorted {
            $0.nom.lowercased() < $1.nom.lowercased()
        }
    }

    var body: some View {
        VStack {
            // Search Bar
            TextField("Rechercher un utilisateur...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)

            // Liste
            List(filteredUsers) { user in
                UserRow(user: user)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Annuaire")
        .onAppear {
            loadUsers()
        }
    }

    private func loadUsers() {
        service.refreshUsers { success in
            if success {
                self.users = service.getAllUsers()
            } else {
                print("❌ Erreur chargement")
            }
        }
    }
}

// MARK: - User Row Component
struct UserRow: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Nom complet
            Text(user.name)
                .font(.headline)

            // Téléphone
            if let phone = user.telephone, !phone.isEmpty {
                PhoneView(phone: phone)
            }

            // Email
            if let mail = user.mail, !mail.isEmpty {
                EmailView(email: mail)
            }

            // Badge type
            if user.type == .fake {
                Text("Compte test")
                    .font(.caption2)
                    .padding(4)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(5)
            } else if user.type == .generic {
                Text("Générique")
                    .font(.caption2)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.gray)
                    .cornerRadius(5)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Phone View with WhatsApp
struct PhoneView: View {
    let phone: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "phone.fill")
                .foregroundColor(.green)

            Menu {
                Button(action: { callPhone() }) {
                    Label("Appeler", systemImage: "phone.fill")
                }
                Button(action: { sendWhatsApp() }) {
                    Label("WhatsApp", systemImage: "message.fill")
                }
                Button(action: { sendMessage() }) {
                    Label("SMS", systemImage: "message.fill")
                }
                Button(action: { copyToClipboard() }) {
                    Label("Copier", systemImage: "doc.on.doc")
                }
            } label: {
                Text(phone)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
            }
        }
    }

    private func callPhone() {
        if let url = URL(string: "tel:\(phone)") {
            UIApplication.shared.open(url)
        }
    }

    private func sendWhatsApp() {
        let formattedPhone = formatPhoneForWhatsApp(phone)

        if let whatsappURL = URL(string: "https://wa.me/\(formattedPhone)") {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL)
            } else if let webURL = URL(string: "https://web.whatsapp.com/send?phone=\(formattedPhone)") {
                UIApplication.shared.open(webURL)
            }
        }
    }

    private func sendMessage() {
        if let url = URL(string: "sms:\(phone)") {
            UIApplication.shared.open(url)
        }
    }

    private func copyToClipboard() {
        UIPasteboard.general.string = phone
    }

    private func formatPhoneForWhatsApp(_ phone: String) -> String {
        let cleanedPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        if cleanedPhone.hasPrefix("0") {
            return "33" + String(cleanedPhone.dropFirst())
        }

        if cleanedPhone.hasPrefix("33") {
            return cleanedPhone
        }

        if cleanedPhone.hasPrefix("+33") {
            return String(cleanedPhone.dropFirst())
        }

        return cleanedPhone
    }
}

// MARK: - Email View
struct EmailView: View {
    let email: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "envelope.fill")
                .foregroundColor(.blue)

            Menu {
                Button(action: { sendEmail() }) {
                    Label("Envoyer un email", systemImage: "envelope.fill")
                }
                Button(action: { copyToClipboard() }) {
                    Label("Copier", systemImage: "doc.on.doc")
                }
            } label: {
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
            }
        }
    }

    private func sendEmail() {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }

    private func copyToClipboard() {
        UIPasteboard.general.string = email
    }
}
