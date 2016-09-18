//
//  GitHubService+Projects.swift
//  GPM
//
//  Created by mtgto on 2016/09/17.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Foundation
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

    func parseProjectsResponse(_ data: Any) -> [GitHubProject]? {
        if let array = data as? Array<[String:Any]> {
            return array.flatMap({ (project) -> GitHubProject? in
                if let number = project["number"] as? Int, let name = project["name"] as? String, let body = project["body"] as? String {
                    return GitHubProject(number: number, name: name, body: body)
                } else {
                    return nil
                }
            })
        } else {
            return []
        }
    }

    public func fetchProjectColumnsForProject(owner: String, repo: String, projectNumber: Int, handler: @escaping (GitHubResponse<[GitHubProject.Column]>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects/columns")!, headers: self.authenticateHeaders())
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

    func parseProjectCardsResponse(_ data: Any) -> [GitHubProject.Card]? {
        if let array = data as? Array<[String:Any]> {
            return array.flatMap({ (card) -> GitHubProject.Card? in
                if let contentId = card["id"] as? Int, let note = card["note"] as? String {
                    return GitHubProject.Card(contentId: contentId, note: note)
                } else {
                    return nil
                }
            })
        }
        return []
    }
}
