//
//  GitHubService+Users.swift
//  GPM
//
//  Created by mtgto on 2016/09/22.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa
import Alamofire

public extension GitHubService {
    public func fetchUser(handler: @escaping (GitHubResponse<GitHubUser>) -> Void) {
        self.fetch(path: "user", parser: self.parseUser, handler: handler)
    }

    func parseUser(_ data: Any) -> GitHubUser? {
        if let user = data as? [String:Any] {
            if let login = user["login"] as? String {
                return GitHubUser(login: login)
            }
        }
        return nil
    }
}
