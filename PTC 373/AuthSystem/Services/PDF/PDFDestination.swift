import SwiftUI
import PDFKit

struct PDFDestination: View {
    let fileName: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // Barre de navigation personnalisée
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("retour")
                            .font(.subheadline)
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))

            if let url = Bundle.main.url(forResource: fileName, withExtension: "pdf", subdirectory: "PDFs") {
                PDFViewer(url: url)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                VStack {
                    Spacer()
                    Text("PDF introuvable")
                        .font(.title)
                    Text("Vérifiez que le fichier \(fileName).pdf existe dans le dossier PDFs")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
