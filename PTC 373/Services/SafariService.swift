import SwiftUI
import SafariServices

class SafariViewManager: ObservableObject {
    @Published var url: URL?
    @Published var isPresented = false

    func openURL(_ url: URL) {
        self.url = url
        self.isPresented = true
    }
}

// MARK: - Vue Safari
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        return SFSafariViewController(url: url, configuration: config)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
