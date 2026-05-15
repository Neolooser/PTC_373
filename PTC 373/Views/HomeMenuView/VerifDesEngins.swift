import SwiftUI
import SafariServices
import PDFKit

struct VerifDesEngins: View {
    // MARK: - Données
    let categories = [
        ("Incendie", "flame.fill"),
        ("SSUAP / SR", "cross.case.fill"),
        ("Opérations Diverses", "ellipsis.circle.fill"),
        ("KIT", "shippingbox.fill")
    ]

    let vehicles = [
        "Incendie": ["FPT1", "FPT2", "EA", "VDA", "RMPGP"],
        "SSUAP / SR": ["VSSUAP", "VSAV", "VSR", "VLI", "VSA", "SACPS"],
        "Opérations Diverses": ["VTU", "VLCI"],
        "KIT": ["KMAP", "KASS", "KMPE", "KPEL", "KBAC", "KCAR", "KTB", "KGEP"]
    ]
    
    let vehicleDisplayNames: [String: String] = [
        "FPT1": "FPT Sides",
        "FPT2": "FPT Renault",
        "EA": "EA",
        "VDA": "VDA",
        "RMPGP": "RMPGP",
        "VSSUAP": "VSSUAP 159",
        "VSAV": "VSAV 79",
        "VSR": "VSR",
        "VLI": "VLI",
        "VSA": "VSA",
        "SACPS": "Sac Prompt-Secours",
        "VTU": "VTU",
        "VLCI": "VL CI",
        "KMAP": "Kit mission assistance aux personnes",
        "KASS": "Kit Asséchement",
        "KMPE": "Kit Moto-Pompe d'épuisement",
        "KPEL": "Kit Pompe éléctrique",
        "KBAC": "Kit bachage",
        "KCAR": "Kit carburant",
        "KTB": "Kit tronçonneuse à bois",
        "KGEP": "Kit groupe électrogene portatif"
    ]

    // MARK: - État
    @StateObject private var safariManager = SafariViewManager()
    @State private var selectedCategoryIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            categoryCarousel
                .padding(.top, 10)
            vehicleList
                .padding(.top, 20)
        }
        .navigationTitle("Vérification des Engins")
        .sheet(isPresented: $safariManager.isPresented) {
            if let url = safariManager.url {
                SafariView(url: url)
                    .id(url.absoluteString)
            }
        }
    }

    // MARK: - Liste des engins
    private var vehicleList: some View {
        let currentVehicles = vehicles[categories[selectedCategoryIndex].0] ?? []

        return ScrollView {
            VStack(spacing: 15) {
                ForEach(currentVehicles, id: \.self) { vehicle in
                    HStack {
                        // Bouton pour le Google Form (clic sur le nom)
                        Button(action: {
                            openGoogleForm(for: vehicle)
                        }) {
                            HStack {
                                Text(vehicleDisplayNames[vehicle] ?? vehicle)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                        }

                        Spacer()

                        // NavigationLink pour le PDF (clic sur l'icône)
                        NavigationLink(destination: PDFDestination(fileName: vehicle)) {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Fonction pour les Google Forms
    private func openGoogleForm(for vehicle: String) {
        let formURLs = [
            "FPT1": "https://docs.google.com/forms/d/1DH5qGEp2W4AP6pXwt8NiSbNb_1pfYDJ9NEs1YkUSTt0/edit",
            "FPT2": "https://docs.google.com/forms/d/1UsuCDWPQvyFj2Ax-kTkD1BJec_WlNj69c3TLAoIa60k/edit",
            "EA": "https://docs.google.com/forms/d/1j5UFjzknikwTfAvl562n4FpRFdOJkdr3l-DWTgem-iQ/edit",
            "VDA": "https://docs.google.com/forms/d/17mn6RcLGo5A_v08Ffybw4uJ7S0jZ4EAs6_Qq7btqlCY/edit",
            "RMPGP": "https://docs.google.com/forms/d/1FAzz_3RsrjkQZ6n7b_quIR3e3fszNRv7imRMWJgpH7o/edit",
            "VSSUAP": "https://docs.google.com/forms/d/1nyDGHv4tFM2CqF6kODT3H4-zHZNSNISmPQq5kOVjJlY/edit?pli=1",
            "VSAV": "https://docs.google.com/forms/d/14wriT1XvsQr6dyuXQbwicBxkrAab2eFxv4gYbB2EFMw/edit",
            "VSR": "https://docs.google.com/forms/d/e/1FAIpQLSfyE2WHDyfkjNL322fHQQEuYsVc4JPv4gIQr11Xkmpi43mS-g/viewform",
            "VLI": "https://docs.google.com/forms/d/1QNOvJl2vcVEFDsOLlwhCsxtpY4dOTucIYt8e5kqXQ7I/edit",
            "VSA": "https://docs.google.com/forms/d/1dysHJ436ijxItryNFpei6ZVpB4MCAK1pT51-GrYQhaI/edit",
            "SACPS": "https://docs.google.com/forms/d/e/1FAIpQLSfeAK1_GEVJAznrXyR1j8e_K62NoCrzt8CrGQhGsPnPfRjOFA/viewform",
            "VTU": "https://docs.google.com/forms/d/1byP5TFDjrx4eCfim7KWFSWheHYwZ-jTU3ajILtSKAXA/edit",
            "VLCI": "https://docs.google.com/forms/d/13OrrzE8ZicScX2K7bP29C0QMnp0iEXBPbKtadcgiy9E/edit",
            "KMAP": "https://docs.google.com/forms/d/1aRnhrX-8bq5RM30TPStqpnDfp4ITZcuEvUtHuKhAQGU/edit",
            "KASS": "https://docs.google.com/forms/d/1NnQXnfvNRNSAS-EzEkob-eF3bkJmgU8kqHKZLMULRBs/edit",
            "KMPE": "https://docs.google.com/forms/d/1ftLantGHs6GQJxFEyvtUssEvqCWHDdxDyRiaElB5JcA/edit",
            "KPEL": "https://docs.google.com/forms/d/1SsoPtLOmjOZqxuG-01wAlUiHyZOasAazOmTyX7G72V4/edit",
            "KBAC": "https://docs.google.com/forms/d/1UbFB28VZrFuTZy-dNMlbOFPG9_eCqR1BA5vHnGRNYuk/edit",
            "KCAR": "https://docs.google.com/forms/d/1kTGnMAkO0NN-JyWOzh_My4nvefdKX2zXs0j55HEmxxg/edit",
            "KTB": "https://docs.google.com/forms/d/120XK87ibUDhK4V1qV2gnO4o5ZEZt4xQ_wHvaHdOcmxw/edit",
            "KGEP": "https://docs.google.com/forms/d/1sdvUC75x_KHIt22DPR9JTWln3AE33lAkaeLPgTEIsBw/edit"
        ]

        if let urlString = formURLs[vehicle], let url = URL(string: urlString) {
            safariManager.openURL(url)
        }
    }

    // MARK: - Carousel
    private var categoryCarousel: some View {
        TabView(selection: $selectedCategoryIndex) {
            ForEach(0..<categories.count, id: \.self) { index in
                VStack(spacing: 10) {
                    Image(systemName: categories[index].1)
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .scaleEffect(1.2)
                    Text(categories[index].0)
                        .font(.title.bold())
                }
                .tag(index)
                .frame(maxWidth: .infinity)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 120)
    }
}

// MARK: - Preview
struct VerifDesEngins_Previews: PreviewProvider {
    static var previews: some View {
        VerifDesEngins()
    }
}
