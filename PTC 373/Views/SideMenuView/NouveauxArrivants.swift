import SwiftUI

struct NouveauxArrivants: View {

    @StateObject private var vm = NouveauxArrivantsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {

                ForEach(vm.arrivants) { personne in
                    ArrivantRow(personne: personne)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Nouveaux arrivants")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            vm.load()
        }
    }
}

// # MARK: - ✅ Cellule intégrée (dans le même fichier)

struct ArrivantRow: View {

    let personne: NouveauxArrivant
    @State private var image: UIImage?

    var body: some View {
        VStack(spacing: 10) {

            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(width: 180, height: 180)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.blue, lineWidth: 3)
            )
            .shadow(radius: 6)

            Text(personne.displayName)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)

            Text(personne.texte)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
        .onAppear {
            NouveauxArrivantsService.shared.fetchImage(
                path: personne.imagePath,
                lastModified: personne.lastModified
            ) {
                self.image = $0
            }
        }
    }
}

// # MARK: - ✅ ViewModel

class NouveauxArrivantsViewModel: ObservableObject {
    @Published var arrivants: [NouveauxArrivant] = []

    func load() {
        NouveauxArrivantsService.shared.fetchNouveauxArrivants { [weak self] data in
            self?.arrivants = data
        }
    }
}
