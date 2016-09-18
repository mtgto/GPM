//
//  GitHubServiceTests.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Foundation
import XCTest
import GPM

class GitHubServiceTests: XCTestCase, GitHubTestsSupport {
    let service = GitHubService()

    func testParseProjectsResponse() {
        let data = self.dataFromResourceFile("response_repos_owner_repo_projects.json")
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let projects = service.parseProjectsResponse(json)
        XCTAssertEqual(projects.map({ $0.count }), Optional(1))
    }

    func testParseProjectColumnsResponse() {
        let data = self.dataFromResourceFile("response_repos_owner_repo_projects_project_number_columns.json")
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let columns = service.parseProjectColumnsResponse(json)
        XCTAssertEqual(columns.map({ $0.count }), Optional(1))
    }

    func testParseProjectCardsResponse() {
        let data = self.dataFromResourceFile("response_repos_owner_repo_projects_columns_column_id_cards.json")
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let columns = service.parseProjectCardsResponse(json)
        XCTAssertEqual(columns.map({ $0.count }), Optional(1))
    }

    func testParseIssueResponse() {
        let data = self.dataFromResourceFile("response_repos_owner_repo_issues_number.json")
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let issue = service.parseIssueResponse(json)
        XCTAssertNotNil(issue)
    }
}
