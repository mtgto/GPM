// SPDX-License-Identifier: MIT

import Foundation
import Observation
import KeychainAccess

@Observable class Store {
    var accessToken: String? = nil

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
            self.accessToken = accessToken.accessToken
        } else {
            Logger.standard.log("No refresh token is stored in Keychain Access")
        }
    }
}
