import SwiftUI

struct SSSM: View {

    @StateObject private var vmIHC = PersonnelViewModel()
    @StateObject private var vmICS = PersonnelViewModel()
    @StateObject private var vmICN = PersonnelViewModel()

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 25) {

                Text("Infirmier")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                SectionTrombiView(title: "Infirmier hors classe", items: vmIHC.personnels)

                SectionTrombiView(title: "Infirmier de classe supérieur", items: vmICS.personnels)

                SectionTrombiView(title: "Infirmier de classe normale", items: vmICN.personnels)
            }
            .padding(.top, 0)
        }
        .onAppear {
            vmIHC.load(folder: "sssm/ihc")
            vmICS.load(folder: "sssm/ics")
            vmICN.load(folder: "sssm/icn")
        }
    }
}
