import SwiftUI

struct Debug: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var gitHubService = GitHubService()
    @State private var bugReportText: String = ""
    @State private var characterCount: Int = 0
    @State private var showSuccessMessage: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    
    private let maxCharacters = 200

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                
                // NOUVELLE SECTION: Rapport de bug
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
        .alert("Succès", isPresented: $showSuccessMessage) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Votre rapport de bug a été envoyé avec succès !")
        }
        .alert("Erreur", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    
    
    // MARK: - Sections existantes

    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Informations Utilisateur")
                .font(.headline)
                .padding(.bottom, 5)

            VStack(alignment: .leading, spacing: 8) {
                infoRow(
                    title: "Nom d'utilisateur:",
                    value: authService.currentUser?.username ?? "Non connecté"
                )

                infoRow(
                    title: "Nom complet:",
                    value: authService.currentUser != nil
                        ? "\(authService.currentUser!.prenom) \(authService.currentUser!.nom)"
                        : "Non connecté"
                )

                infoRow(
                    title: "Email:",
                    value: authService.currentUser?.mail ?? "Non renseigné"
                )

                infoRow(
                    title: "Statut:",
                    value: authService.isAuthenticated ? "Connecté" : "Déconnecté"
                )

                infoRow(
                    title: "Niveaux:",
                    value: authService.currentUser?.levels
                        .map { $0.displayName }
                        .joined(separator: ", ") ?? "Aucun"
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
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

    // MARK: - NOUVELLE SECTION: Rapport de bug

    private var bugReportSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(spacing: 10) {
                Text("Retour de Bug")
                    .font(.headline)

                Text("Afin de garantir une meilleure expérience utilisateur, merci de remonter ici tout bug ou problème constaté sur l'application.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $bugReportText)
                        .frame(height: 150)
                        .padding(4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: bugReportText) { newValue in
                            if newValue.count > maxCharacters {
                                bugReportText = String(newValue.prefix(maxCharacters))
                            }
                            characterCount = bugReportText.count
                        }

                    if bugReportText.isEmpty {
                        Text("Décrivez brièvement le problème ici...")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                            .padding(.top, 12)
                    }
                }

                HStack {
                    Spacer()
                    Text("\(characterCount)/\(maxCharacters)")
                        .font(.caption)
                        .foregroundColor(characterCount == maxCharacters ? .red : .gray)
                }

                Button(action: submitBugReport) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Envoyer le rapport")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(bugReportText.isEmpty)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }

    // MARK: - Méthodes utilitaires (inchangées)

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

    // MARK: - Méthode d'envoi de bug

    private func submitBugReport() {
        guard let user = authService.currentUser else {
            errorMessage = "Vous devez être connecté pour signaler un bug"
            showErrorAlert = true
            return
        }

        let title = "Bug report from \(user.username)"
        let body = """
        **Utilisateur:** \(user.prenom) \(user.nom) (\(user.username))
        **Niveau(x) d'accès:** \(user.levels.map { $0.displayName }.joined(separator: ", "))

        **Description du bug:**
        \(bugReportText)
        """

        gitHubService.createIssue(title: title, body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    bugReportText = ""
                    characterCount = 0
                    showSuccessMessage = true
                case .failure(let error):
                    errorMessage = "Échec de l'envoi: \(error.localizedDescription)"
                    showErrorAlert = true
                }
            }
        }
    }
}
