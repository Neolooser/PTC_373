import SwiftUI

struct ServiceDetailViewInfra: View {

    // Exemple de liste des membres du service
    let membres = [
        "SCH Alexis \nNavasse",
        "SCH Florian \nRobin",
        "SGT Florian \nGalpin",
        "SGT Maxime \nParvaud",
        "CCH Jonathan \nRey",
        "CPL Julien \nRebillon",
        "SAP Julien \nCaspar"
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

                    Image("") // Remplacez par image chef de service
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

                    Text("ADC Yann Baudic")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                Image("") // Remplacez par image chef de service
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

                Text("ADC Jérôme Berodier")
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
                        text: "Gestion des opérations de petite maintenance courantes du CIS, par l’évaluation des tâches à accomplir et la tenue d’un registre à disposition des gradés de jour"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion du contrôle d’accès CIS"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Organisation et planification des travaux d’ampleur relatifs à l’amélioration et à l’entretien du CIS"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Organisation et planification de l’entretien du CIS, avec le contrat initiative 77"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Gestion et mise à disposition des consommables / produits d’entretien"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Suivi des incidents infra sur l’intranet"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Suivi de l’exécution des contrats du syndicat intercommunal"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Développement du plateau pédagogique du CIS et ses outils"
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


