// SPDX-License-Identifier: MIT

import Foundation
import Observation
import KeychainAccess

@Observable class Store {
    var accessToken: String? = nil
    // The username in GitHub
    var me: String? = nil

    init() {
        let keychain = Keychain(service: "net.mtgto.gpm")
        accessToken = keychain["GitHubAccessToken"]
    }

    func storeAccessToken(_ accessToken: String) {
        let keychain = Keychain(service: "net.mtgto.gpm")
        keychain["GitHubAccessToken"] = accessToken
    }
}
