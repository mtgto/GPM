//
//  GitHubService.swift
//  GPM
//
//  Created by mtgto on 2016/09/17.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa
import Alamofire

public struct GitHubResponse<T> {
    public let scopes: [String]
    public let result: GitHubResult<T>
}

public enum GitHubResult<T> {
    case Success(T)
    case Failure(GitHubError)
}

public enum GitHubError: Error {
    case NetworkError
    case ParseError
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

    internal func fetch<T>(path: String, parser: @escaping (Any) -> T?, handler: @escaping (GitHubResponse<T>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent(path)!, headers: self.authenticateHeaders())
            .responseJSON { response in
                let scopes = self.parseScopesFromResponse(response.response)
                switch response.result {
                case .success(let value):
                    // TODO: Check status code (200 or other)
                    if let parsedValue = parser(value) {
                        handler(GitHubResponse(scopes: scopes, result: GitHubResult.Success(parsedValue)))
                    } else {
                        handler(GitHubResponse(scopes: scopes, result: GitHubResult.Failure(GitHubError.ParseError)))
                    }
                case .failure(let error):
                    print(error)
                    handler(GitHubResponse(scopes: scopes, result: GitHubResult.Failure(GitHubError.NetworkError)))
                }
        }
    }

    internal func parseScopesFromResponse(_ response: HTTPURLResponse?) -> [String] {
        if let response = response, let scopesString = response.allHeaderFields["X-OAuth-Scopes"] as? String {
            return scopesString.components(separatedBy: ", ")
        } else {
            return []
        }
    }
}
