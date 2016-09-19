//
//  GitHubService.swift
//  GPM
//
//  Created by mtgto on 2016/09/17.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa
import Alamofire

public enum GitHubResponse<T> {
    case Success(T)
    case Failure(GitHubError)
}

public enum GitHubError: Error {
    case NetworkError
}

public class GitHubService: NSObject {
    static let sharedInstance: GitHubService = GitHubService()

    var accessToken: String = ""

    /**
     * API endpoint URL. This url must end with a slash.
     */
    var baseURL: NSURL = NSURL(string: "https://api.github.com/")!

    internal func authenticateHeaders() -> [String:String] {
        return [
            "Authorization": "token \(self.accessToken)",
            "Accept": "application/vnd.github.inertia-preview+json" // Projects API is still in Early Access. See https://developer.github.com/v3/repos/projects/
        ]
    }
}
