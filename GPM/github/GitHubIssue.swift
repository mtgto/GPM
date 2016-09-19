//
//  GitHubIssue.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

public enum GitHubIssueType {
    case Issue
    case PullRequest
}

public class GitHubIssueId: Hashable, Equatable {
    let owner: String
    let repo: String
    let number: Int
    private let id: String

    init(owner: String, repo: String, number: Int) {
        self.owner = owner
        self.repo = repo
        self.number = number
        self.id = "\(owner)/\(repo)/\(number)"
    }

    public var hashValue: Int {
        return self.id.hashValue
    }
}

public func ==(lhs: GitHubIssueId, rhs: GitHubIssueId) -> Bool {
    return lhs.owner == rhs.owner && lhs.repo == rhs.repo && lhs.number == rhs.number
}

public class GitHubIssue: NSObject {
    let id: GitHubIssueId

    let type: GitHubIssueType

    let title: String

    let body: String //! markdown

    init(id: GitHubIssueId, type: GitHubIssueType, title: String, body: String) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
    }
}
