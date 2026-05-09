import Foundation
import SwiftUI

struct Trombinoscope: View {

    let items = [
        ("Officiers", "Officiers", Color.white),
        ("CATE", "CATE", Color.yellow),
        ("CA1", "CA1", Color.blue),
        ("HDR", "HDR", Color.red),
        ("SSSM", "SSSM", Color.green)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {

                ForEach(items, id: \.0) { item in

                    NavigationLink(destination: destinationView(for: item.0)) {
                        ServiceCircleView(
                            title: item.0,
                            imageName: item.1,
                            color: item.2
                        )
                    }
                }
            }
            .padding()
        }
    }

    // ✅ Navigation dynamique vers la bonne vue
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Officiers":
            Officiers()
        case "CATE":
            CATE()
        case "CA1":
            CA1()
        case "HDR":
            HDR()
        case "SSSM":
            SSSM()
        default:
            Text("Page introuvable")
        }
    }
}

struct SectionTrombiView: View {

    let title: String
    let items: [Personnel]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { person in
                        PersonnelCardView(personnel: person)
                            .frame(width: 140) // ✅ largeur FIXE propre
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
