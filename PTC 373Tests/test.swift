import SwiftUI

struct Debug: View {
    @EnvironmentObject var authService: AuthService
    @State private var bugReportText: String = ""
    @State private var characterCount: Int = 0
    private let maxCharacters = 200

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Nouvelle section d'information
                infoSection

                // Section de rapport de bug
                bugReportSection

                // Section Informations Utilisateur
                userInfoSection

                // Section Niveaux d'accès
                accessLevelsSection

                // Section Actions
                actionButtonsSection

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Support & Débug")
    }

    // MARK: - Nouvelle section d'information
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Support Utilisateur")
                .font(.headline)

            Text("Afin de garantir une meilleure expérience utilisateur, merci de remonter ici tout bug ou problème constaté sur l'application.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // MARK: - Nouvelle section de rapport de bug
    private var bugReportSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rapport de bug")
                .font(.headline)

            ZStack(alignment: .topLeading) {
                if bugReportText.isEmpty {
                    Text("Décrivez ici brièvement le problème (max \(maxCharacters) caractères)")
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }

                TextEditor(text: $bugReportText)
                    .frame(minHeight: 120)
                    .onChange(of: bugReportText) { newValue in
                        if newValue.count > maxCharacters {
                            bugReportText = String(newValue.prefix(maxCharacters))
                        }
                        characterCount = bugReportText.count
                    }
                    .padding(4)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )

            HStack {
                Spacer()
                Text("\(characterCount)/\(maxCharacters)")
                    .font(.caption)
                    .foregroundColor(characterCount == maxCharacters ? .red : .gray)
            }

            Button(action: {
                submitBugReport()
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Envoyer le rapport")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(bugReportText.isEmpty || bugReportText.count < 10)
            .padding(.top, 5)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // MARK: - Sections existantes (inchangées)
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Informations Utilisateur")
                .font(.headline)
                .padding(.bottom, 5)

            VStack(alignment: .leading, spacing: 8) {
                infoRow(title: "Nom d'utilisateur:", value: authService.currentUser?.username ?? "Non connecté")
                infoRow(title: "Nom complet:", value: authService.getUserFullName())
                infoRow(title: "Statut:", value: authService.isAuthenticated ? "Connecté" : "Déconnecté")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }

    private var accessLevelsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Niveaux d'accès")
                .font(.headline)
                .padding(.bottom, 5)

            if let levels = authService.currentUser?.levels, !levels.isEmpty {
                VStack(spacing: 8) {
                    ForEach(levels, id: \.self) { level in
                        HStack {
                            Image(systemName: levelIcon(for: level))
                                .foregroundColor(levelColor(for: level))
                                .frame(width: 20)

                            Text(level.displayName)
                                .font(.subheadline)

                            Spacer()

                            Text(level.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(levelColor(for: level), lineWidth: 1)
                        )
                    }
                }
            } else {
                Text("Aucun niveau d'accès")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }

    private var actionButtonsSection: some View {
        VStack(spacing: 15) {
            Text("Actions")
                .font(.headline)

            if authService.isAuthenticated {
                Button(action: {
                    authService.logout()
                }) {
                    HStack {
                        Image(systemName: "arrow.left.square")
                        Text("Déconnexion")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                Text("Aucune action disponible")
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - Méthodes utilitaires
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }

    private func levelIcon(for level: UserLevel) -> String {
        switch level {
        case .admin: return "checkerboard.shield"
        case .chefDeCentre: return "person.badge.shield.checkmark.fill"
        case .operateur: return "brain"
        case .chefDeService: return "person.crop.rectangle.stack"
        case .gdj: return "person.wave.2.fill"
        case .membre: return "person.text.rectangle"
        case .infirmier: return "cross.case.circle"
        }
    }

    private func levelColor(for level: UserLevel) -> Color {
        switch level {
        case .admin: return .red
        case .chefDeCentre: return .blue
        case .operateur: return .purple
        case .chefDeService: return .orange
        case .gdj: return .yellow
        case .membre: return .gray
        case .infirmier: return .green
        }
    }

    // MARK: - Nouvelle méthode pour soumettre le rapport
    private func submitBugReport() {
        // Ici vous implémenteriez la logique pour envoyer le rapport
        // Par exemple : envoyer à un serveur, sauvegarder localement, etc.

        print("Rapport de bug envoyé: \(bugReportText)")

        // Réinitialiser le champ après envoi
        bugReportText = ""
        characterCount = 0

        // Vous pourriez ajouter une alerte de confirmation
        // Ou une animation de feedback
    }
}

// Preview
struct Debug_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Debug()
                .environmentObject(AuthService())
        }
    }
}
