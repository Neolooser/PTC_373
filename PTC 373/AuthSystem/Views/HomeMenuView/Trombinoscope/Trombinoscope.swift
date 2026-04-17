import Foundation
import SwiftUI

// MARK: - Vue Associatif (4 éléments)
struct Trombinoscope: View {
    let Trombinoscope = [
        ("Officiers", "Officiers", Color.white),
        ("CATE", "CATE", Color.yellow),
        ("CA1", "CA1", Color.blue),
        ("HDR", "HDR", Color.red),
        ("SSSM", "SSSM", Color.green)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(Trombinoscope, id: \.0) { Trombinoscope in
                    NavigationLink(destination: TrombinoscopeDetailView(title: Trombinoscope.0)) {
                        ServiceCircleView(title: Trombinoscope.0, imageName: Trombinoscope.1, color: Trombinoscope.2)
                    }
                }
            }
            .padding()
        }
    }
}

struct TrombinoscopeDetailView: View {
    let title: String

    var body: some View {
        VStack {
            Text("Bientôt disponibles...")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle(title)
    }
}
