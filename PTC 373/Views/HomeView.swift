import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showMenu = false
    @State private var todaysBirthdays: [User] = []
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showPortalCode = false
    @State private var portalCode = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    private let pdfs = [
        (fileName: "reglement_interieur", title: "Règlement intérieur")
    ]
    private let birthdayService = BirthdayService()

    private var menuItems: [AppMenuItem] {
        var items = [
            AppMenuItem(title: "Lisez-moi", icon: "text.badge.checkmark", destination: Lisez_moi()),
            AppMenuItem(title: "Annuaire", icon: "person.text.rectangle", destination: Annuaire()),
            AppMenuItem(title: "Documents de formation", icon: "doc.text.below.ecg", destination: DocumentsDeFormation()),
            AppMenuItem(title: "Remise", icon: "box.truck", destination: Remise()),
            AppMenuItem(title: "Compagnie", icon: "person.3", destination: CompagnieView()),
            AppMenuItem(title: "Médiathèque", icon: "photo.on.rectangle.angled", destination: MediaLibraryView()),
            AppMenuItem(title: "Gazette PTC", icon: "newspaper", destination: GazettePTC()),
            AppMenuItem(title: "Nouveaux Arrivants", icon: "person.badge.plus", destination: NouveauxArrivants()),
            AppMenuItem(title: "Evenement", icon: "checkmark.circle", destination: Sondages()),
            AppMenuItem(title: "Débug", icon: "ant", destination: Debug()),
            AppMenuItem(title: "Confidentialités", icon: "text.justify.left", destination: Confidentialités())
        ]

        items.append(
            AppMenuItem(
                title: "Déconnexion",
                icon: "arrow.left.square",
                action: {
                    authService.logout()
                }
            )
        )

        return items
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 15) {
                        if let uiImage = UIImage(named: "banner") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 10)
                        }

                        VStack(spacing: 15) {
                            NavigationLink(destination: VerifDesEngins()) {
                                Text("Verifications des Engins")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 16)
                        }

                        VStack(spacing: 15) {
                            NavigationLink(destination: Organigramme()) {
                                Text("Organigramme")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 16)
                        }

                        VStack(spacing: 15) {
                            NavigationLink(destination: Trombinoscope()) {
                                Text("Trombinoscope")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 16)
                        }

                        VStack(spacing: 15) {
                            ForEach(pdfs, id: \.fileName) { pdf in
                                NavigationLink(destination: PDFDestination(fileName: pdf.fileName)) {
                                    Text(pdf.title)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }

                        VStack(spacing: 15) {
                            NavigationLink(destination: OrganisationDesGardes()) {
                                Text("Organisation des gardes")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 16)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Anniversaires du jour 🎉")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)

                            if isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                            } else if !todaysBirthdays.isEmpty {
                                if todaysBirthdays.count <= 3 {
                                    HStack(spacing: 12) {
                                        ForEach(todaysBirthdays) { member in
                                            birthdayCard(member)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 16)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(todaysBirthdays) { member in
                                                birthdayCard(member)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                }
                            } else {
                                Text("Aucun anniversaire aujourd'hui 😢")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
                .navigationTitle("Accueil")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showMenu.toggle()
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showPortalCode = true
                        }) {
                            Image(systemName: "door.garage.double.bay.closed")
                                .imageScale(.large)
                        }
                    }
                }
                .onAppear {
                    loadBirthdays()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    loadBirthdays()
                }

                // Menu latéral
                SideMenuView(isShowing: $showMenu, menuItems: menuItems)

                // Popup pour le code du portail
                if showPortalCode {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showPortalCode = false
                        }

                    VStack(spacing: 20) {
                        Text("Accès Portail")
                            .font(.headline)
                            .padding(.top)

                        SecureField("Code d'accès", text: $portalCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                            .onSubmit {
                                validatePortalCode()
                            }

                        if isLoading {
                            ProgressView()
                                .padding(.bottom)
                        } else {
                            HStack(spacing: 20) {
                                Button("Annuler") {
                                    showPortalCode = false
                                    portalCode = ""
                                }
                                .foregroundColor(.red)

                                Button("Valider") {
                                    validatePortalCode()
                                }
                                .foregroundColor(.blue)
                            }
                            .padding(.bottom)
                        }
                    }
                    .frame(width: 300)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage.contains("succès") ? "Succès" : "Information"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("succès") {
                            // Action après succès si nécessaire
                        }
                    }
                )
            }
        }
        .navigationViewStyle(.stack)
    }

    // Carte anniversaire
    @ViewBuilder
    private func birthdayCard(_ user: User) -> some View {
        VStack(spacing: 4) {
            Text(user.name)
                .font(.caption)
                .multilineTextAlignment(.center)

            (
                Text("\(user.age)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.orange)
                +
                Text(" ans")
                    .font(.caption)
                    .foregroundColor(.orange)
            )
            .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // Chargement des anniversaires
    private func loadBirthdays() {
        isLoading = true

        // Force le rafraîchissement des données utilisateurs
        birthdayService.refreshBirthdays { success in
            DispatchQueue.main.async {
                if success {
                    self.todaysBirthdays = self.birthdayService.getTodaysBirthdays()
                } else {
                    self.errorMessage = "Impossible de charger les anniversaires"
                    self.showError = true
                }
                self.isLoading = false
            }
        }
    }

    // Validation du code du portail
    private func validatePortalCode() {
        guard !portalCode.isEmpty else {
            alertMessage = "Veuillez entrer un code"
            showAlert = true
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            makeHTTPRequest()
        }
    }

    // Requête HTTP GET
    private func makeHTTPRequest() {
        let urlString = "https://ptcportal.jsp-pontault.fr/x7Kp9/relais?code=\(portalCode)"

        guard let url = URL(string: urlString) else {
            isLoading = false
            alertMessage = "URL invalide"
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    alertMessage = "Erreur réseau: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    alertMessage = "Réponse invalide du serveur"
                    showAlert = true
                    return
                }

                let responseText = String(data: data ?? Data(), encoding: .utf8) ?? ""

                print("Réponse brute:", responseText)

                switch httpResponse.statusCode {
                case 200:
                    // 👉 adapter selon ton ESP
                    if responseText.contains("OK") {
                        alertMessage = "Portail ouvert"
                    } else if responseText.contains("INVALID") {
                        alertMessage = "❌ Code faux ❌"
                    } else {
                        alertMessage = "Commande envoyée"
                    }

                    showPortalCode = false
                    portalCode = ""

                case 403:
                    alertMessage = "❌ Accès refusé ❌"

                case 404:
                    alertMessage = "❌ URL incorrecte ❌"

                default:
                    alertMessage = "Erreur serveur: \(httpResponse.statusCode)"
                }

                showAlert = true
            }
        }.resume()
    }

}
