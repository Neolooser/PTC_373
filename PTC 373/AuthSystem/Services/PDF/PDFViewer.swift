import SwiftUI
import PDFKit

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
