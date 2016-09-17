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
    public func fetchProjectsForRepository(owner: String, repo: String, handler: (GitHubResponse<[GitHubProject]>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects")!, headers: self.authenticateHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    let projects = self.parseProjectsResponse(value)
                case .failure(let error):
                    print(error)
                }
        }
    }

    func parseProjectsResponse(_ data: Data) -> [GitHubProject]? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? Array<[String:Any]> {
            return array.flatMap({ (project) -> GitHubProject? in
                if let number = project["number"] as? Int, let name = project["name"] as? String, let body = project["body"] as? String {
                    return GitHubProject(number: number, name: name, body: body)
                } else {
                    return nil
                }
            })
        }
        return []
    }

    public func fetchProjectColumnsForProject(owner: String, repo: String, projectNumber: Int, handler: (GitHubResponse<[GitHubProject.Column]>) -> Void) {
        Alamofire.request(self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/projects/columns")!, headers: self.authenticateHeaders())
            .responseJSON { response in
            }
    }

    func parseProjectColumnsResponse(_ data: Data) -> [GitHubProject.Column]? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? Array<[String:Any]> {
            return array.flatMap({ (column) -> GitHubProject.Column? in
                if let name = column["name"] as? String {
                    return GitHubProject.Column(name: name)
                } else {
                    return nil
                }
            })
        }
        return []
    }
}
