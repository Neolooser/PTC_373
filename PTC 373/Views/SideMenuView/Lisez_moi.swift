import SwiftUI

struct Lisez_moi: View {
    var body: some View {  // <-- NavigationStack principal (obligatoire)
            ScrollView {
                VStack(spacing: 20) {
                    BodyLisezMoi  // <-- Intégration directe de la sous-vue
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Lisez-moi")  // <-- Titre de navigation
        
    }

    // Sous-vue CORRIGÉE (sans NavigationStack)
    private var BodyLisezMoi: some View {
        VStack(spacing: 10) {
            Text("""
                Bienvenue sur l'application du CIS Pontault-Combault

                Cette application a été créée dans le but de centraliser tous les outils dont vous pouvez avoir besoin dans votre quotidien à la caserne.

                En pleine évolution, certains onglets et options ne sont pas encore opérationnels, mais le seront sous peu.

                N'hésitez pas à nous faire des retours dans l'onglet "Bug".
                """)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

            HStack {
                Spacer()
                VStack(spacing: 5) {
                    Image("com_logo")  // <-- Assure-toi que cette image existe dans tes assets
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("La Com")
                        .font(.footnote)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
