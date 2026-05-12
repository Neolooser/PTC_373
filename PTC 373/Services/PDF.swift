import SwiftUI
import PDFKit

// MARK : - PdfDestination
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

// MARK : - PDFViewer
struct PDFViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.pageShadowsEnabled = false
        pdfView.displaysPageBreaks = false
        pdfView.usePageViewController(false)

        if let pdfDocument = PDFKit.PDFDocument(url: url) {
            pdfView.document = pdfDocument
        } else {
            print("❌ Impossible de lire le PDF à l'URL : \(url)")
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFKit.PDFView, context: Context) {
        if let pdfDocument = PDFKit.PDFDocument(url: url) {
            uiView.document = pdfDocument
        }
    }
}
