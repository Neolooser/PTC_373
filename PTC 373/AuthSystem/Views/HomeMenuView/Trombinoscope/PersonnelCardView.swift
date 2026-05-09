import SwiftUI

struct PersonnelCardView: View {

    let personnel: Personnel
    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 180)
                    .clipped()
                    .cornerRadius(12)
            } else {
                ProgressView()
                    .frame(width: 220, height: 260)
            }

            Text(personnel.displayName)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .onAppear {
            PersonnelService.shared.fetchImage(path: personnel.imagePath) { img in
                self.image = img
            }
        }
    }
}
