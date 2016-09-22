//
//  AccessTokenService.swift
//  GPM
//
//  Created by mtgto on 2016/09/21.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa
import KeychainAccess

class AccessTokenService: NSObject {
    static let sharedInstance: AccessTokenService = AccessTokenService()

    private static let ServiceName = "net.mtgto.GPM.github-accesstoken"

    private static let AccessTokenKey = "api.github.com"

    func accessToken() -> String? {
        let keychain = Keychain(service: AccessTokenService.ServiceName)
        return try! keychain.get(AccessTokenService.AccessTokenKey)
    }

    func setAccessToken(_ accessToken: String) {
        let keychain = Keychain(service: AccessTokenService.ServiceName)
        keychain[AccessTokenService.AccessTokenKey] = accessToken
    }
}
