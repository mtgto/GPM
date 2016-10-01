//
//  GitHubIssue.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

public enum GitHubIssueType: String {
    case Issue = "issue"
    case PullRequest = "pull_request"
}

public class GitHubIssueId: NSObject, NSCoding {
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

    public override var hashValue: Int {
        return self.id.hashValue
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        self.owner = aDecoder.decodeObject(forKey: "owner") as! String
        self.repo = aDecoder.decodeObject(forKey: "repo") as! String
        self.number = aDecoder.decodeInteger(forKey: "number")
        self.id = "\(owner)/\(repo)/\(number)"
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.owner, forKey: "owner")
        aCoder.encode(self.repo, forKey: "repo")
        aCoder.encode(self.number, forKey: "number")
    }

    // MARK: - Equatable
    override public func isEqual(_ object: Any?) -> Bool {
        guard let issueId = object as? GitHubIssueId else {
            return false
        }
        return self == issueId
    }
}

public func ==(lhs: GitHubIssueId, rhs: GitHubIssueId) -> Bool {
    return lhs.owner == rhs.owner && lhs.repo == rhs.repo && lhs.number == rhs.number
}

public class GitHubIssue: NSObject, NSCoding {
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

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! GitHubIssueId
        self.type = GitHubIssueType(rawValue: aDecoder.decodeObject(forKey: "type") as! String)!
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.body = aDecoder.decodeObject(forKey: "body") as! String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.body, forKey: "body")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let issue = object as? GitHubIssue else {
            return false
        }
        return self == issue
    }
}

public func ==(lhs: GitHubIssue, rhs: GitHubIssue) -> Bool {
    return lhs.id == rhs.id && lhs.type == rhs.type && lhs.title == rhs.title && lhs.body == rhs.body
}
