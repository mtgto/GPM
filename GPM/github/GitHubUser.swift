//
//  GitHubUser.swift
//  GPM
//
//  Created by mtgto on 2016/09/22.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

public class GitHubUser: NSObject {
    public let login: String

    init(login: String) {
        self.login = login
    }
}
