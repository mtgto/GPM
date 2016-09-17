//
//  GitHubServiceTests.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import XCTest
import GPM

class GitHubServiceTests: XCTestCase, GitHubTestsSupport {
    let service = GitHubService()

    func testParseProjectsResponse() {
        let data = self.dataFromResourceFile("response_repos_owner_repo_projects.json")
        let projects = service.parseProjectsResponse(data)
        XCTAssertEqual(projects.map({ $0.count }), Optional(1))
    }

    func testParseProjectColumnsResponse() {
        let data = self.dataFromResourceFile("response_repos_owner_repo_projects_project_number_columns.json")
        let columns = service.parseProjectColumnsResponse(data)
        XCTAssertEqual(columns.map({ $0.count }), Optional(1))
    }
}
