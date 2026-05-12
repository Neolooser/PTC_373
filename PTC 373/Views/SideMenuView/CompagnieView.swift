import SwiftUI
import SafariServices

struct CompagnieView: View {
    // MARK: - État
    @StateObject private var safariManager = SafariViewManager()
    @StateObject private var viewModel = CompagnieViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Partie haute - Bouton AGENDIS
            agendisButton
                .padding(.horizontal, 20)
                .padding(.top, 20)

            // Partie basse - Liste des besoins
            needsList
                .padding(.top, 20)
        }
        .navigationTitle("Compagnie")
        .sheet(isPresented: $safariManager.isPresented) {
            if let url = safariManager.url {
                SafariView(url: url)
                    .id(url.absoluteString)
            }
        }
        .onAppear {
            viewModel.fetchNeeds()
        }
    }

    // MARK: - Bouton AGENDIS
    private var agendisButton: some View {
        Button(action: {
            if let url = URL(string: "https://sdis77.sdis77.fr") {
                safariManager.openURL(url)
            }
        }) {
            Text("AGENDIS")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }

    // MARK: - Liste des besoins en personnel
    private var needsList: some View {
        VStack(spacing: 0) {
            // Titre de la section
            HStack {
                Text("Besoins en personnels - \(viewModel.currentMonth)")
                    .font(.headline)
                    .padding(.leading, 20)
                    .padding(.vertical, 10)

                Spacer()
            }
            .background(Color(.systemBackground))

            // Liste des dates
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.needs.isEmpty {
                Text("Aucun besoin ce mois-ci")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.needs, id: \.self) { need in
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.red)
                                Text(need)
                                    .font(.body)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
    }
}

// MARK: - ViewModel pour gérer les données
class CompagnieViewModel: ObservableObject {
    @Published var needs: [String] = []
    @Published var isLoading = false
    @Published var currentMonth: String = ""

    init() {
        updateCurrentMonth()
    }

    func fetchNeeds() {
        isLoading = true

        // Simulation de récupération depuis Google Sheets
        // Dans une vraie implémentation, vous utiliseriez Google Sheets API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.needs = [
                "Bientôt Disponible"
            ]
            self.isLoading = false
        }
    }

    private func updateCurrentMonth() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "MMMM yyyy"
        currentMonth = formatter.string(from: Date()).capitalized
    }
}
