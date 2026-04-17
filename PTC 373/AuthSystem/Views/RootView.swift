import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {

        if auth.isLoading {
            ProgressView() // ou SplashScreen
        }
        else if auth.isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}
