import SwiftUI

struct ServiceDetailViewHabillement: View {

    // Exemple de liste des membres du service
    let membres = [
        "SCH Mallory Ricozzi",
        "SCH Vianney Seguy"
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

                    Text("Responsable Formation")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("ADC David Chauvière")
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

                    Text("Responsable Sport")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("ADJ Julien Rochefeuille")
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
                        text: "Suivi des candidatures aux stages et gestion des remplacements / annulations"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Mise en place des dispositifs destinés au maintien des acquis des SPV"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Suivi des aptitudes opérationnelles"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Organisation des FC SUAP formations internes : EA / VDA / SINUS / VSA / LSA / VLSM"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Suivi de la validité des Permis de conduire et cod ACCR(VL-PL)"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Encadrement quotidien des séances d’activité physique"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Réalisation des Indicateurs de Condition Physique"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Contrôle réglemantaire, entretien et Développement des équipements"
                    )
                    missionRow(
                        icon: "checkmark.circle.fill",
                        text: "Suivi des personnels en reprise et accompagnement personnalisé"
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


