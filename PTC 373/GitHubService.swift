import Foundation

class GitHubService {
    private let token: String
    private let repoOwner: String
    private let repoName: String

    // Initialiseur avec paramètres
    init(token: String, repoOwner: String, repoName: String) {
        self.token = token
        self.repoOwner = repoOwner
        self.repoName = repoName
    }

    func createIssue(title: String, body: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://api.github.com/repos/\(repoOwner)/\(repoName)/issues")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let issue = GitHubIssue(title: title, body: body, labels: ["bug"])
        request.httpBody = try? JSONEncoder().encode(issue)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            completion(.success(true))
        }.resume()
    }
}

struct GitHubIssue: Codable {
    let title: String
    let body: String
    let labels: [String]
}
