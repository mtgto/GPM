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
                if try await generateAccessToken() {
                    let me = try await GithubClient().me()
                    Logger.standard.info("Hello, \(me)!")
                    self.me = me
                } else {
                    Logger.standard.info("Failed to generate GitHub Access Token")
                }
            } catch {
                Logger.standard.error("Error occurred: \(error)")
            }
        }
    }

    func storeRefreshToken(_ refreshToken: String) {
        let keychain = Keychain(service: "net.mtgto.gpm")
        keychain["GitHubRefreshToken"] = refreshToken
    }

    // Generate GitHub Access Token by using Refresh Token
    func generateAccessToken() async throws -> Bool {
        let keychain = Keychain(service: "net.mtgto.gpm")
        if let refreshToken = keychain["GitHubRefreshToken"] {
            Logger.standard.info("Generate GitHub Access Token from Refresh Token…")
            guard let clientId = Bundle.main.infoDictionary?["GITHUB_CLIENT_ID"] as? String,
                  let clientSecret = Bundle.main.infoDictionary?["GITHUB_CLIENT_SECRET"] as? String else {
                return false
            }
            do {
                let accessToken = try await GithubClient().generateAccessToken(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken)
                Logger.standard.log("Successfully generated GitHub Access Token from GitHub Refresh Token")
                self.accessToken = accessToken.accessToken
                keychain["GitHubRefreshToken"] = accessToken.refreshToken
                keychain["GitHubAccessToken"] = accessToken.accessToken
            } catch let error as GithubClient.AccessTokenError {
                try keychain.remove("GitHubRefreshToken")
                try keychain.remove("GitHubAccessToken")
                Logger.standard.log("Error: Delete refresh token because it is already invalid")
                throw error
            }
            return true
        } else {
            Logger.standard.log("No refresh token is stored in Keychain Access")
            return false
        }
    }
}
