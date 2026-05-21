import SwiftUI

struct ServiceDetailViewCom: View {

    // Exemple de liste des membres du service
    let membres = [
        "CPL Anthony \nNoel",
        "SCH Fabien \nDe Toffol",
        "SGT Ryan \nGuillard",
        "CPL Aline \nRenaux",
        "CPL Océane \nBichler",
        "ISP Maxime \nLeveques"
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

                    Image("Noe")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                        )
                        .shadow(radius: 6)

                    Text("Responsable du service")
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

                    Text("Membres du service")
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
                        text: "Mise à jour des annuaires, listes de diffusion et photos, etiquettes pour bannettes et casier"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Communication interne et externe du CIS"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion des moyens techniques et informatique de communication du CIS"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Suivi de l’application du CIS"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion du trombinoscope"
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


