
import SwiftUI

struct AssoDetailViewJSP: View {

    // Exemple de liste des membres du service
    let membres = [
        "SCH Fabien De Toffol\nVice-Président",
        "CPL Thiebaut Altmayer\nSecrétaire",
        "SCH Pierre Fouet\nTrésorier",
        "CPL Matthieu Rousseau",
        "CPL Valentin Bibens"
    ]

    // 2 colonnes centrées
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {

        ScrollView {

            VStack(spacing: 25) {

                // MARK: - Responsable du service

                VStack(spacing: 10) {

                    Image("Noe") // Photo président
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                        )
                        .shadow(radius: 6)

                    Text("Président")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("SCH Nicolas Noe")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                // MARK: - Membres du service

                VStack(spacing: 15) {

                    Text("Membres du bureau")
                        .font(.title3)
                        .bold()

                    LazyVGrid(columns: columns, spacing: 15) {

                        ForEach(membres, id: \.self) { membre in

                            Text(membre)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)



                // MARK: - Missions du service

                VStack(alignment: .leading, spacing: 18) {

                    HStack {
                        Image(systemName: "checklist")
                            .font(.title2)
                            .foregroundColor(.blue)

                        Text("Missions du service")
                            .font(.title2)
                            .bold()
                    }

                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion et suivi des entretiens des matériels du CIS"
                    )
                    
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion et suivi des entretiens des véhicules du CIS"
                    )

                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion de la PUI"
                    )

                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion des Carburants"
                    )

                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion espace remise"
                    )

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.15),
                            Color.gray.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1.5)
                )
                .cornerRadius(20)
                .padding(.horizontal)
                
                
            }
        }
        .navigationTitle("Service")
        .navigationBarTitleDisplayMode(.inline)
    }
    @ViewBuilder
    private func missionRow(icon: String, text: String) -> some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.title3)

            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
    }
}


