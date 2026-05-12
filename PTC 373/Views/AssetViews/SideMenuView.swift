import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    let menuItems: [AppMenuItem]
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ZStack {
            // Fond semi-transparent
            if isShowing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }

            HStack {
                // Contenu du menu
                VStack(alignment: .leading, spacing: 0) {
                    // En-tête
                    HStack {
                        Image("ptc_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.trailing, 10)

                        VStack(alignment: .leading) {
                            Text("PTC 373")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        Button(action: {
                            withAnimation {
                                isShowing = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                                .padding()
                        }
                    }
                    .padding()

                    // Liste des éléments
                    List {
                        ForEach(menuItems) { item in
                            if let destination = item.destination {
                                // Cas normal: NavigationLink
                                NavigationLink(destination: destination) {
                                    HStack {
                                        Image(systemName: item.icon)
                                            .frame(width: 20)
                                        Text(item.title)
                                    }
                                }
                            } else if let action = item.action {
                                // Cas spécial: Bouton avec action (ex: Déconnexion)
                                Button(action: {
                                    action()
                                    withAnimation {
                                        isShowing = false
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: item.icon)
                                            .frame(width: 20)
                                            .foregroundColor(.red)
                                        Text(item.title)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .frame(width: 250)
                .background(Color(.systemBackground))
                .offset(x: isShowing ? 0 : -250)
                .animation(.easeInOut, value: isShowing)

                Spacer()
            }
        }
    }
}
