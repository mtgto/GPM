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
                    state = generateRandomString()
                    let url = URL(string: "https://github.com/login/oauth/authorize")?.appending(queryItems: [
                        URLQueryItem(name: "client_id", value: "Iv23li2yrtFAg5H5hoTp"),
                        URLQueryItem(name: "redirect_uri", value: "net.mtgto.gpm://callback"),
                        URLQueryItem(name: "state", value: state),
                    ])
                    do {
                        let urlWithToken = try await webAuthenticationSession.authenticate(
                            using: url!,
                            callbackURLScheme: "net.mtgto.gpm"
                        )
                        // Retrieve code and state params from callback url
                        debugPrint("Success! url = \(urlWithToken)")
                    } catch {
                        debugPrint("Failed to authorize: \(error)")
                        didFailed = true
                    }
                    isStarting = false
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
