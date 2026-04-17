import SwiftUI

@main
struct MyApp: App {
    @StateObject private var authService = AuthService() 

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authService)
        }
    }
}
