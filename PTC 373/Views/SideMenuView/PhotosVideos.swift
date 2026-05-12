import SwiftUI

class DriveViewModel: ObservableObject {
    @Published var files: [GDriveFile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchFiles() {
        isLoading = true
        errorMessage = nil

        GoogleDriveService.shared.fetchFiles { [weak self] files in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let files = files {
                    self?.files = files
                } else {
                    self?.errorMessage = "Échec du chargement des fichiers"
                }
            }
        }
    }
}

struct MediaLibraryView: View {
    @StateObject private var viewModel = DriveViewModel()
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.files.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(viewModel.files.filter { $0.isImage }) { file in
                                MediaItemView(file: file)
                            }
                        }
                        .padding(.top, 0)
                        .padding(.horizontal, 1)
                    }
                }
            }
            .navigationTitle("Médiathèque")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Médiathèque")
                        .font(.headline)
                }
            }
            .refreshable {
                viewModel.fetchFiles()
            }
            .alert("Erreur", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                viewModel.fetchFiles()
            }
        }
    }
}

struct MediaItemView: View {
    let file: GDriveFile
    @State private var isShowingDetail = false

    var body: some View {
        Button(action: {
            isShowingDetail = true
        }) {
            if let thumbnailURL = file.thumbnailURL {
                AsyncImage(url: thumbnailURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 120)
                .clipped()
            } else {
                Color.gray
                    .frame(height: 120)
            }
        }
        .fullScreenCover(isPresented: $isShowingDetail) {
            if let fullSizeURL = URL(string: "https://drive.google.com/uc?export=view&id=\(file.id)") {
                ImageDetailView(imageURL: fullSizeURL, isPresented: $isShowingDetail)
            }
        }
    }
}

struct ImageDetailView: View {
    let imageURL: URL
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 20)
                } placeholder: {
                    ProgressView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
