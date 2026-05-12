import SwiftUI

struct Organigramme: View {
    var body: some View {
        VStack(spacing: 0) {
            // Partie haute avec chef de centre et adjoint
            topSection
                .padding(.top, 20)
                .padding(.bottom, 20)

            // Partie basse avec les 4 images rondes
            bottomSection
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Organigramme")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Partie haute (chef et adjoint)
    private var topSection: some View {
        VStack(spacing: 20) {
            // Chef de centre
            VStack(spacing: 5) {
                Image("chef_centre") // Remplacez par votre image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .shadow(radius: 5)

                Text("Chef de centre")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text("CNE Arthur Levy Falk")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }

            // Adjoint
            VStack(spacing: 8) {
                Text("Adjoint")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text("LTN Gitlaw Loïc")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Partie basse (4 images rondes)
    private var bottomSection: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.45

            VStack(spacing: 15) {
                HStack(spacing: 0) {
                    // Top Left
                    NavigationLink(destination: Services()) {
                        Image("Services")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.red, lineWidth: 2))
                            .shadow(radius: 5)
                    }

                    Spacer()

                    // Top Right
                    NavigationLink(destination: Referents()) {
                        Image("Référents") // Remplacez par votre image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                }

                Spacer()

                HStack(spacing: 0) {
                    // Bottom Left
                    NavigationLink(destination: Tuteurs()) {
                        Image("Tuteurs") // Remplacez par votre image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.green, lineWidth: 2))
                            .shadow(radius: 5)
                    }

                    Spacer()

                    // Bottom Right
                    NavigationLink(destination: Associatif()) {
                        Image("Associatif") // Remplacez par votre image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                }
            }
            .padding(15)
        }
    }
}

// MARK: - Vue de destination pour les sections
struct SectionView: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .padding()

            // Ajoutez ici le contenu spécifique à chaque section
            Text("Détails de la \(title)")
                .foregroundColor(.gray)
        }
        .navigationTitle(title)
    }
}
