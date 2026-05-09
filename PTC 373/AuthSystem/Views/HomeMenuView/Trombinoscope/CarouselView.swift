import SwiftUI

struct CarouselView: View {

    let items: [Personnel]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(items) { person in
                    PersonnelCardView(personnel: person)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
