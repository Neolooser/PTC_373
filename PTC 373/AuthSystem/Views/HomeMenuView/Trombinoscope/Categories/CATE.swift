import SwiftUI

struct CATE: View {

    @StateObject private var vmADC = PersonnelViewModel()
    @StateObject private var vmADJ = PersonnelViewModel()

    var body: some View {
        ScrollView {

            VStack(alignment: .leading, spacing: 25) {

                Text("CATE")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                SectionTrombiView(title: "ADC", items: vmADC.personnels)

                SectionTrombiView(title: "ADJ", items: vmADJ.personnels)
            }
            .padding(.top, 0)
        }
        .onAppear {
            vmADC.load(folder: "cate/adc")
            vmADJ.load(folder: "cate/adj")
        }
    }
}
