//
//  GitHubService+Issues.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Foundation
import Alamofire

public extension GitHubService {
    public func fetchIssue(owner: String, repo: String, number: Int, handler: @escaping (GitHubResponse<GitHubIssue>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/issues/\(number)")!, headers: self.authenticateHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // TODO: Check status code (200 or other)
                    if let issue = self.parseIssueResponse(value, owner: owner, repo: repo) {
                        handler(GitHubResponse.Success(issue))
                    }
                case .failure(let error):
                    print(error)
                    handler(GitHubResponse.Failure(GitHubError.NetworkError))
                }
        }
    }

    func parseIssueResponse(_ data: Any, owner: String, repo: String) -> GitHubIssue? {
        if let issue = data as? [String:Any] {
            if let number = issue["number"] as? Int, let title = issue["title"] as? String, let body = issue["body"] as? String {
                let issueType = issue["pull_request"] != nil ? GitHubIssueType.PullRequest : GitHubIssueType.Issue
                return GitHubIssue(id: GitHubIssueId(owner: owner, repo: repo, number: number), type: issueType, title: title, body: body)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
