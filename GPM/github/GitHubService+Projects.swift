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
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects")!, headers: self.authenticateHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // TODO: Check status code (200 or other)
                    if let projects = self.parseProjectsResponse(value) {
                        handler(GitHubResponse.Success(projects))
                    }
                case .failure(let error):
                    print(error)
                    handler(GitHubResponse.Failure(GitHubError.NetworkError))
                }
        }
    }

    public func fetchProject(owner: String, repo: String, projectNumber: Int, handler: @escaping (GitHubResponse<GitHubProject>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects/\(projectNumber)")!, headers: self.authenticateHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // TODO: Check status code (200 or other)
                    if let project = self.parseProjectResponse(value) {
                        handler(GitHubResponse.Success(project))
                    }
                case .failure(let error):
                    print(error)
                    handler(GitHubResponse.Failure(GitHubError.NetworkError))
                }
        }
    }

    public func fetchProjectColumnsForProject(owner: String, repo: String, projectNumber: Int, handler: @escaping (GitHubResponse<[GitHubProject.Column]>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects/\(projectNumber)/columns")!, headers: self.authenticateHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // TODO: Check status code (200 or other)
                    if let columns = self.parseProjectColumnsResponse(value) {
                        handler(GitHubResponse.Success(columns))
                    }
                case .failure(let error):
                    print(error)
                    handler(GitHubResponse.Failure(GitHubError.NetworkError))
                }
            }
    }

    public func fetchProjectCardsForProjectColumn(owner: String, repo: String, columnId: Int, handler: @escaping (GitHubResponse<[GitHubProject.Card]>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects/columns/\(columnId)/cards")!, headers: self.authenticateHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // TODO: Check status code (200 or other)
                    if let cards = self.parseProjectCardsResponse(value) {
                        handler(GitHubResponse.Success(cards))
                    }
                case .failure(let error):
                    print(error)
                    handler(GitHubResponse.Failure(GitHubError.NetworkError))
                }
        }
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
