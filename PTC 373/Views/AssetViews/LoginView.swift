import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService

    //@State private var accessCode = ""
    @State private var username = ""
    @State private var password = ""

    //@State private var showAccessCode = false
    @State private var showPassword = false

    var body: some View {
        VStack(spacing: 20) {

            Image("ptc_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text("Connexion")
                .font(.largeTitle)
                .bold()

            TextField("adresse email", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            /*HStack {
                if showAccessCode {
                    TextField("Code d'accès", text: $accessCode)
                } else {
                    SecureField("Code d'accès", text: $accessCode)
                }

                Button {
                    showAccessCode.toggle()
                } label: {
                    Image(systemName: showAccessCode ? "eye.slash" : "eye")
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())*/

            HStack {
                if showPassword {
                    TextField("Mot de passe", text: $password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    SecureField("Mot de passe", text: $password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = authService.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Se connecter") {
                authService.login(
                    //accessCode: accessCode,
                    email: username,
                    password: password
                )
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

        }
        .padding()
    }
}
