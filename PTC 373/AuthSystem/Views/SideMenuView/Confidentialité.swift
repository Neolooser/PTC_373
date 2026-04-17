import SwiftUI

struct Confidentialités: View {

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 16) {

                Group {

                    // Titre
                    Text("Politique de Confidentialité")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 8)

                    // Introduction
                    Text("Engagement RGPD de la Caserne")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 4)

                    Text("""
                    En rejoignant notre caserne, vous avez signé un engagement à respecter le Règlement Général sur la Protection des Données (RGPD). Cette politique explique comment nous traitons vos données personnelles, notamment les photos partagées sur l'application.
                    """)
                    .font(.body)
                    .padding(.bottom, 8)

                    // Section 1
                    Text("1. Utilisation des Photos des Membres")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 4)

                    Text("""
                    • Finalité : Les photos partagées sur l'application sont utilisées uniquement dans le cadre des activités de la caserne.

                    • Consentement : Votre consentement est recueilli lors de l'inscription.

                    • Stockage : Les photos sont stockées de manière sécurisée.

                    • Durée de conservation : Les photos sont conservées tant que vous êtes membre actif.
                    """)
                    .font(.body)
                    .padding(.bottom, 8)

                    // Section 2
                    Text("2. Vos Droits (RGPD)")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 4)
                }

                Group {

                    Text("""
                    Conformément au RGPD, vous disposez des droits suivants :

                    • Accès : Demander une copie de vos données.

                    • Rectification : Corriger vos informations personnelles.

                    • Effacement : Supprimer vos données.

                    • Limitation : Restreindre le traitement de vos données.

                    • Portabilité : Récupérer vos données.

                    • Opposition : Vous opposer au traitement de vos données.

                    Contact : Service Communication
                    """)
                    .font(.body)
                    .padding(.bottom, 8)

                    // Section 3
                    Text("3. Sécurité des Données")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 4)

                    Text("""
                    Nous mettons en place des mesures techniques et organisationnelles pour protéger vos données contre :

                    • Les accès non autorisés.

                    • Les pertes de données.

                    • Les fuites de données.

                    Les photos sont chiffrées lors du stockage et du transfert.
                    """)
                    .font(.body)
                    .padding(.bottom, 8)

                    // Section 4
                    Text("4. Modifications de la Politique")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 4)

                    Text("""
                    Cette politique peut être mise à jour pour refléter les changements législatifs ou les évolutions de l'application.
                    """)
                    .font(.body)
                    .padding(.bottom, 8)

                    // Date
                    Text("Dernière mise à jour : \(formattedDate())")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 16)
                }
            }
            .padding()
        }
        .navigationTitle("Confidentialité")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Date FR
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: Date())
    }
}
