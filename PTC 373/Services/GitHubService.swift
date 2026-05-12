import Foundation

class GitHubService: ObservableObject {
    private(set) var token: String = ""
    private(set) var repoOwner: String = ""
    private(set) var repoName: String = ""
    private let configURL = URL(string: "https://drive.google.com/uc?export=download&id=1IF9NKmuFwuRgbTnVF6aE5bR1bItwaSFs")!
    init() {
        loadConfig()
    }

    private func loadConfig() {
        URLSession.shared.dataTask(with: configURL) { data, response, error in
            if let error = error {
                print("⚠️ Erreur de chargement du fichier JSON : \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("⚠️ Aucune donnée reçue.")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
                    DispatchQueue.main.async {
                        self.token = json["github_token"] ?? ""
                        self.repoOwner = json["repo_owner"] ?? ""
                        self.repoName = json["repo_name"] ?? ""
                    }
                }
            } catch {
                print("⚠️ Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }

    func createIssue(title: String, body: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !token.isEmpty else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token GitHub non chargé."])))
            return
        }

        let url = URL(string: "https://api.github.com/repos/\(repoOwner)/\(repoName)/issues")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let issueData: [String: Any] = [
            "title": title,
            "body": body,
            "labels": ["bug"]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: issueData)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Échec de création de l'issue"])))
                return
            }

            completion(.success(()))
        }.resume()
    }
}
