import SwiftUI

struct MainView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Text("Bienvenue \(authService.currentUser?.prenom ?? "")")
                    .font(.title)

                Button("Se déconnecter") {
                    authService.logout()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

            }
            .navigationTitle("Accueil")
        }
    }
}
