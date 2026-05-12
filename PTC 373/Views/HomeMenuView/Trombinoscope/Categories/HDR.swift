import SwiftUI

struct HDR: View {

    @StateObject private var vmCCH = PersonnelViewModel()
    @StateObject private var vmCPL = PersonnelViewModel()
    @StateObject private var vmSAP = PersonnelViewModel()

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 25) {

                Text("HDR")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                SectionTrombiView(title: "CCH", items: vmCCH.personnels)

                SectionTrombiView(title: "CPL", items: vmCPL.personnels)

                SectionTrombiView(title: "SAP", items: vmSAP.personnels)
            }
            .padding(.top, 0)
        }
        .onAppear {
            vmCCH.load(folder: "hdr/cch")
            vmCPL.load(folder: "hdr/cpl")
            vmSAP.load(folder: "hdr/sap")
        }
    }
}
