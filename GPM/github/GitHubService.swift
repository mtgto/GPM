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
    case NoTokenError
    case NetworkError
    case ParseError
}

public class GitHubService: NSObject {
    static let sharedInstance: GitHubService = GitHubService()

    var accessToken: String? = nil

    var server: GitHubServer = GitHubServer(
        apiBaseURL: NSURL(string: "https://api.github.com/")!,
        webBaseURL: NSURL(string: "https://github.com/")!
    )

    internal func authenticateHeaders(_ accessToken: String) -> [String:String] {
        return [
            "Authorization": "token \(accessToken)",
            "Accept": "application/vnd.github.inertia-preview+json" // Projects API is still in Early Access. See https://developer.github.com/v3/repos/projects/
        ]
    }

    internal func fetch<T>(path: String, parser: @escaping (Any) -> T?, handler: @escaping (GitHubResponse<T>) -> Void) {
        self.request(path: path, method: .get, parser: parser, handler: handler)
    }

    internal func post<T>(path: String, method: Alamofire.HTTPMethod = .post, parameters: [String:Any]? = nil, parser: @escaping (Any) -> T?, handler: @escaping (GitHubResponse<T>) -> Void) {
        self.request(path: path, method: method, parameters: parameters, encoding: JSONEncoding.default, parser: parser, handler: handler)
    }

    fileprivate func request<T>(path: String, method: Alamofire.HTTPMethod, parameters: [String:Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, parser: @escaping (Any) -> T?, handler: @escaping (GitHubResponse<T>) -> Void) {
        guard let accessToken = self.accessToken else {
            handler(GitHubResponse(scopes: [], result: GitHubResult.Failure(.NoTokenError)))
            return
        }
        Alamofire.request(self.server.apiBaseURL.appendingPathComponent(path)!, method: method, parameters: parameters, encoding: encoding, headers: self.authenticateHeaders(accessToken))
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
