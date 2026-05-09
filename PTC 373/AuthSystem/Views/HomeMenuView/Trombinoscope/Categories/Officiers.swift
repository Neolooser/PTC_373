import SwiftUI

struct Officiers: View {

    @StateObject private var vmCNE = PersonnelViewModel()
    @StateObject private var vmLTN = PersonnelViewModel()

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 25) {

                Text("Officiers")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                SectionTrombiView(title: "Capitaine", items: vmCNE.personnels)

                SectionTrombiView(title: "Lieutenant", items: vmLTN.personnels)
            }
            .padding(.top, 0)
        }
        .onAppear {
            vmCNE.load(folder: "Officiers/cne")
            vmLTN.load(folder: "Officiers/ltn")
        }
    }
}
