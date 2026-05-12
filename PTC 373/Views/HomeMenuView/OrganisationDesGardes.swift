import SwiftUI

struct OrganisationDesGardes: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                header
                
                section(title: "📍 Arrivée au CI") {
                    Text("Se signaler sur la feuille de garde du jour en faisant une marque à côté de son nom.")
                }
                
                section(title: "⏰ Rassemblement matin") {
                    bullet("Lundi, mercredi et jeudi : 07H30")
                    bullet("Mardi, vendredi, samedi et dimanche : 08H00")
                }
                
                section(title: "🏃‍♂️ Sport") {
                    bullet("Lundi et jeudi : piscine Nautil (douche sur place)")
                    bullet("Mercredi : espace forme Nautil (douche sur place)")
                    bullet("Vendredi : escalade (créneau dans l’après-midi)")
                }
                
                section(title: "🌤️ Rassemblement après-midi") {
                    bullet("Lundi, mercredi et jeudi : 14H30")
                    bullet("Mardi et vendredi : 14H00")
                    bullet("Vendredi : tenue de feu + vérification des EPIS")
                }
                
                section(title: "💪 Sport libre") {
                    Text("À partir de 17H00")
                }
                
                section(title: "🛏️ Couchage") {
                    bullet("Noter son nom sur le tableau à l’entrée des chambres")
                    bullet("Le matin : nettoyer, aérer puis appuyer sur \"My\" des volets")
                    bullet("Avant de partir : barrer son nom sans l’effacer")
                }
            }
            .padding()
        }
        .navigationTitle("Organisation\ndes gardes") // ✅ retour à la ligne
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Composants

extension OrganisationDesGardes {
    
    var header: some View {
        Text("Guide pour préparer vos gardes 👨‍🚒")
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
    }
    
    func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            content()
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
    
    func bullet(_ text: String) -> some View {
        HStack(alignment: .top) {
            Text("•")
            Text(text)
        }
    }
}
