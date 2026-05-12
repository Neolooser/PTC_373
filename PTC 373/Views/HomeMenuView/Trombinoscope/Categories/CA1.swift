import SwiftUI

struct CA1: View {

    @StateObject private var vmSCH = PersonnelViewModel()
    @StateObject private var vmSGT = PersonnelViewModel()

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 25) {

                Text("CA1")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                SectionTrombiView(title: "SCH", items: vmSCH.personnels)

                SectionTrombiView(title: "SGT", items: vmSGT.personnels)
            }
            .padding(.top, 0)
        }
        .onAppear {
            vmSCH.load(folder: "ca1/sch")
            vmSGT.load(folder: "ca1/sgt")
        }
    }
}
