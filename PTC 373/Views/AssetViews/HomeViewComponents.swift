import SwiftUI

// Composant pour les boutons PDF
struct PDFButton: View {
    let title: String
    let fileName: String

    var body: some View {
        NavigationLink(destination: PDFDestination(fileName: fileName)) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// Composant pour la section anniversaires
struct BirthdaySection: View {
    let birthdays: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Anniversaires du jour")
                .font(.headline)
                .padding(.bottom, 5)

            if birthdays.isEmpty {
                Text("Aucun anniversaire aujourd'hui")
                    .foregroundColor(.gray)
            } else {
                ForEach(birthdays, id: \.self) { name in
                    Text("• \(name)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
