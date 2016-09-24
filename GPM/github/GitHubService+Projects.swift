//
//  GitHubService+Projects.swift
//  GPM
//
//  Created by mtgto on 2016/09/17.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa
import Alamofire

public extension GitHubService {
    public func fetchProjectsForRepository(owner: String, repo: String, handler: @escaping (GitHubResponse<[GitHubProject]>) -> Void) {
        self.fetch(path: "repos/\(owner)/\(repo)/projects", parser: self.parseProjectsResponse, handler: handler)
    }

    public func fetchProject(owner: String, repo: String, projectNumber: Int, handler: @escaping (GitHubResponse<GitHubProject>) -> Void) {
        self.fetch(path: "repos/\(owner)/\(repo)/projects/\(projectNumber)", parser: self.parseProjectResponse, handler: handler)
    }

    public func fetchProjectColumnsForProject(owner: String, repo: String, projectNumber: Int, handler: @escaping (GitHubResponse<[GitHubProject.Column]>) -> Void) {
        self.fetch(path: "repos/\(owner)/\(repo)/projects/\(projectNumber)/columns", parser: self.parseProjectColumnsResponse, handler: handler)
    }

    public func fetchProjectCardsForProjectColumn(owner: String, repo: String, columnId: Int, handler: @escaping (GitHubResponse<[GitHubProject.Card]>) -> Void) {
        self.fetch(path: "repos/\(owner)/\(repo)/projects/columns/\(columnId)/cards", parser: self.parseProjectCardsResponse, handler: handler)
    }

    // See https://developer.github.com/v3/repos/projects/#move-a-project-card
    public func updateProjectCardPosition(owner: String, repo: String, cardId: Int, position: GitHubProject.Card.Position, columnId: Int?, handler: @escaping (GitHubResponse<Void>) -> Void) {
        var parameters: [String: Any]
        switch position {
        case .Top:
            parameters = ["position": "top"]
        case .Bottom:
            parameters = ["position": "bottom"]
        case .After(let cardId):
            parameters = ["position": "after:\(cardId)"]
        }
        if let columnId = columnId {
            parameters.updateValue(columnId, forKey: "column_id")
        }
        self.post(path: "repos/\(owner)/\(repo)/projects/columns/cards/\(cardId)/moves", parameters: parameters, parser: { _ -> Void in }, handler: handler)
    }

    func parseProjectsResponse(_ data: Any) -> [GitHubProject]? {
        if let array = data as? Array<[String:Any]> {
            return array.flatMap({ self.parseProjectResponse($0) })
        } else {
            return []
        }
    }

    func parseProjectResponse(_ data: Any) -> GitHubProject? {
        if let project = data as? [String:Any] {
            if let number = project["number"] as? Int, let name = project["name"] as? String, let body = project["body"] as? String {
                return GitHubProject(number: number, name: name, body: body)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func parseProjectColumnsResponse(_ data: Any) -> [GitHubProject.Column]? {
        if let array = data as? Array<[String:Any]> {
            return array.flatMap({ (column) -> GitHubProject.Column? in
                if let id = column["id"] as? Int, let name = column["name"] as? String {
                    return GitHubProject.Column(id: id, name: name)
                } else {
                    return nil
                }
            })
        }
        return []
    }

    func parseProjectCardsResponse(_ data: Any) -> [GitHubProject.Card]? {
        if let array = data as? Array<[String:Any]> {
            return array.flatMap({ (card) -> GitHubProject.Card? in
                if let id = card["id"] as? Int {
                    let note = card["note"] as? String
                    let contentURL = (card["content_url"] as? String).flatMap({NSURL(string: $0)})
                    let issueId = contentURL.flatMap({ (contentURL) -> GitHubIssueId? in
                        if let pathComponents = contentURL.pathComponents {
                            let count = pathComponents.count
                            if count >= 5 && pathComponents[count - 5] == "repos" {
                                let owner = pathComponents[count - 4]
                                let repo = pathComponents[count - 3]
                                let number = Int(pathComponents[count - 1])!
                                return GitHubIssueId(owner: owner, repo: repo, number: number)
                            }
                        }
                        return nil
                    })
                    return GitHubProject.Card(id: id, note: note, issueId: issueId)
                } else {
                    return nil
                }
            })
        }
        return []
    }
}
