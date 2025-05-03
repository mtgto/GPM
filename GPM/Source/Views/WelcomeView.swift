// SPDX-License-Identifier: MIT

import SwiftUI
import AuthenticationServices
import SwiftData

/**
 * Show Authorize button if no refresh token is stored in Keychain.
 */
struct WelcomeView: View {
    @State var starting = false
    @State var didFailed = false
    @State var state: String = ""
    @State var project: (owner: GithubProjectOwner, number: Int)?
    @State var showingAddProject: Bool = false
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(Store.self) private var store: Store
    @Query private var projects: [GithubProject]

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Spacer()
                Image(systemName: "app")
                //Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .frame(width: 128, height: 128)
                Text("GPM")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("v0.0.0")
                Spacer()
                WelcomeActionView(iconName: "lock", title: "Authorize") {
                    starting = true
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
                            URLQueryItem(name: "scope", value: "project"),
                        ])
                        defer {
                            starting = false
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
                            Logger.standard.debug("Access token: \(accessToken.accessToken)")
                            store.storeAccessToken(accessToken.accessToken)
                            store.accessToken = accessToken.accessToken
                        } catch {
                            Logger.standard.log("Failed to authorize: \(error)")
                            didFailed = true
                        }
                    }
                }
                .alert("Error", isPresented: $didFailed) {

                } message: {
                    Text("Failed to start authorization")
                }
                if store.accessToken != nil {
                    WelcomeActionView(iconName: "plus.app", title: "Add Project") {
                        showingAddProject = true
                    }
                }
                Spacer()
            }
            .padding()
            .frame(width: 460)
            List(projects) { project in
                VStack(alignment: .leading) {
                    Text(project.title)
                        .font(.title3)
                    Text("\(project.owner.login)/\(project.number)")
                        .font(.subheadline)
                }
            }
            .frame(width: 280)
            .background(.thickMaterial) // Use .containerBackground(.thickMaterial, for: .window) for macOS 15+
        }
        .frame(width: 740, height: 460)
        .sheet(isPresented: $showingAddProject) {
            OpenProjectView(project: $project, editing: $showingAddProject)
        }
    }

    func generateRandomString() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in characters.randomElement()!})
    }
}

#Preview {
    @Previewable var store = {
        let store = Store()
        store.accessToken = "12345"
        return store
    }()

    WelcomeView()
        .environment(store)
        .modelContainer(previewContainer)
}
