import SwiftUI

// MARK: - Vue Services (8 éléments)
struct Services: View {
    let services = [
        ("Materiel", "REMISE", Color.red),
        ("Habillement", "Habillement", Color.orange),
        ("Infra", "Infra", Color.green),
        ("Compagnie", "Compagnie", Color.purple),
        ("Prévision", "Prévision", Color.blue),
        ("Com", "COM", Color.yellow),
        ("Formation / Sport", "Formation_Sport", Color.gray),
        ("Volontariat", "Volontariat", Color.pink)
    ]
    @ViewBuilder
    private func destinationView(for service: String) -> some View {

        switch service {

        case "Materiel":
            ServiceDetailViewMateriel()

        case "Habillement":
            ServiceDetailViewHabillement()

        case "Infra":
            ServiceDetailViewInfra()

        case "Compagnie":
            ServiceDetailViewCompagnie()

        case "Prévision":
            ServiceDetailViewPrevision()

        case "Com":
            ServiceDetailViewCom()

        case "Formation / Sport":
            ServiceDetailViewFormationSport()

        case "Volontariat":
            ServiceDetailViewVolontariat()

        default:
            Text("Service introuvable")
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(services, id: \.0) { service in
                    NavigationLink(destination: destinationView(for: service.0)) {
                        ServiceCircleView(
                            title: service.0,
                            imageName: service.1,
                            color: service.2
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Services")
    }
}

// MARK: - Vue Tuteurs (4 éléments)
struct Tuteurs: View {
    let tuteurs = [
        ("Cavallo", "Cavallo", Color.blue),
        ("SGT De Toffol\nFabien", "DeToffol", Color.green),
        ("Ruiz", "Ruiz", Color.orange),
        ("Bichler", "Bichler", Color.red),
        ("Varela", "Varela", Color.yellow)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(tuteurs, id: \.0) { tuteur in
                    ServiceCircleView(title: tuteur.0, imageName: tuteur.1, color: tuteur.2)
                }
            }
            .padding()
        }
        .navigationTitle("Tuteurs")
    }
}

// MARK: - Vue Référents (6 éléments)
struct Referents: View {
    let referents = [
        ("Conduite", "COND", Color.yellow),
        ("Nexis", "Nexsis", Color.red),
        ("Sport", "EAP", Color.blue),
        ("SSUAP / Tablettes", "Tablette", Color.pink),
        ("VSA / SINUS", "VSA", Color.orange),
        ("ASTECH", "", Color.purple),
        ("Base VLI", "VLI", Color.green)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(referents, id: \.0) { referent in
                    NavigationLink(destination: ReferentDetailView(title: referent.0)) {
                        ServiceCircleView(title: referent.0, imageName: referent.1, color: referent.2)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Référents")
    }
}

// MARK: - Vue Associatif (4 éléments)
struct Associatif: View {
    let associations = [
        ("Amicale", "", Color.blue),
        ("COS", "COS", Color.pink),
        ("JSP", "JSP", Color.green),
        ("Lupins", "Lupins", Color.orange),
        ("ASSAP", "ASSAP", Color.red)
    ]

    @ViewBuilder
    private func destinationView(for asso: String) -> some View {

        switch asso {

        case "Amicale":
            AssoDetailViewAmicale()

        case "COS":
            AssoDetailViewCOS()

        case "JSP":
            AssoDetailViewJSP()

        case "Lupins":
            AssoDetailViewLupins()

        case "ASSAP":
            AssoDetailViewASSAP()
            
        default:
            Text("Asso introuvable")
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(associations, id: \.0) { asso in
                    NavigationLink(destination: destinationView(for: asso.0)) {
                        ServiceCircleView(
                            title: asso.0,
                            imageName: asso.1,
                            color: asso.2
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Associatif")
    }
}

// MARK: - Vue réutilisable pour les cercles
struct ServiceCircleView: View {
    let title: String
    let imageName: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 2)
                )
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 3)
                )

            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .frame(width: 80)
        }
    }
}

struct TuteurDetailView: View {
    let title: String

    var body: some View {
        VStack {
            Text("Détails du tuteur \(title)")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle(title)
    }
}

struct ReferentDetailView: View {
    let title: String

    var body: some View {
        VStack {
            Text("Détails du référent \(title)")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle(title)
    }
}

struct AssociationDetailView: View {
    let title: String

    var body: some View {
        VStack {
            Text("Détails de l'association \(title)")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle(title)
    }
}
//TEST
