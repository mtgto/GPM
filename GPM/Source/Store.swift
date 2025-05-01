// SPDX-License-Identifier: MIT

import Foundation
import Observation
import KeychainAccess

@Observable class Store {
    var accessToken: String? = nil
    // The username in GitHub
    var me: String? = nil

    init() {
        Task {
            do {
                try await generateAccessToken()
                let me = try await GithubClient().me()
                Logger.standard.info("Hello, \(me)!")
                self.me = me
            } catch {
                Logger.standard.error("Error occurred: \(error)")
            }
        }
    }

    func storeRefreshToken(_ refreshToken: String) {
        let keychain = Keychain(service: "net.mtgto.gpm")
        keychain["GitHubRefreshToken"] = refreshToken
    }

    func generateAccessToken() async throws {
        let keychain = Keychain(service: "net.mtgto.gpm")
        if let refreshToken = keychain["GitHubRefreshToken"] {
            Logger.standard.info("Generate GitHub Access Token from Refresh Token…")
            guard let clientId = Bundle.main.infoDictionary?["GITHUB_CLIENT_ID"] as? String,
            let clientSecret = Bundle.main.infoDictionary?["GITHUB_CLIENT_SECRET"] as? String else {
                return
            }
            let accessToken = try await GithubClient().generateAccessToken(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken)
            // TODO: Delete refresh token from Keychain if refresh token is expired
            Logger.standard.log("Successfully generated GitHub Access Token from GitHub Refresh Token")
            self.accessToken = accessToken.accessToken
            keychain["GitHubAccessToken"] = accessToken.accessToken
        } else {
            Logger.standard.log("No refresh token is stored in Keychain Access")
        }
    }
}
