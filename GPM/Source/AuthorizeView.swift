// SPDX-License-Identifier: MIT

import SwiftUI
import AuthenticationServices

struct AuthorizeView: View {
    @State var isStarting = false
    @State var didFailed = false
    @State var state: String = ""
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession

    var body: some View {
        VStack {
            Text("GitHub Projectの情報の取得・操作のためにGitHub Appをインストールします。Authorizeをクリックすると続行します")
                .multilineTextAlignment(.center)
            Button {
                isStarting = true
                Task {
                    guard let clientId = Bundle.main.infoDictionary?["GITHUB_CLIENT_ID"] as? String else {
                        didFailed = true
                        return
                    }
                    state = generateRandomString()
                    let authorizeUrl = URL(string: "https://github.com/login/oauth/authorize")?.appending(queryItems: [
                        URLQueryItem(name: "client_id", value: clientId),
                        URLQueryItem(name: "redirect_uri", value: "net.mtgto.gpm://callback"),
                        URLQueryItem(name: "state", value: state),
                    ])
                    defer {
                        isStarting = false
                    }
                    do {
                        let urlWithToken = try await webAuthenticationSession.authenticate(
                            using: authorizeUrl!,
                            callbackURLScheme: "net.mtgto.gpm"
                        )
                        // Retrieve code and state params from callback url
                        guard let urlComponents = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false),
                              let queryItems = urlComponents.queryItems,
                              let code = queryItems.first(where: { $0.name == "code" })?.value,
                              let state = queryItems.first(where: { $0.name == "state" })?.value else {
                            didFailed = true
                            return
                        }
                        guard state == self.state else {
                            debugPrint("State mismatch!")
                            didFailed = true
                            return
                        }
                        guard let clientSecret = Bundle.main.infoDictionary?["GITHUB_CLIENT_SECRET"] as? String else {
                            didFailed = true
                            return
                        }
                        let accessToken = try await GithubClient().generateAccessToken(clientId: clientId, clientSecret: clientSecret, code: code)
                        debugPrint("Access token: \(accessToken)")
                    } catch {
                        debugPrint("Failed to authorize: \(error)")
                        didFailed = true
                    }
                }
            } label: {
                Text("Authorize")
            }
            .alert("Error", isPresented: $didFailed) {

            } message: {
                Text("Failed to start authorization")
            }
        }
        .padding()
    }

    func generateRandomString() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in characters.randomElement()!})
    }
}

#Preview {
    AuthorizeView()
}
