//
//  CardTests.swift
//  GPM
//
//  Created by mtgto on 2016/10/01.
//  Copyright © 2016 mtgto. All rights reserved.
//

import XCTest
@testable import GPM

class CardTests: XCTestCase {
    func testSerializeCardHasNote() {
        let source = Card(id: 123, note: "this is note", issue: nil)
        let data = NSKeyedArchiver.archivedData(withRootObject: source)
        guard let dest = NSKeyedUnarchiver.unarchiveObject(with: data) as? Card else {
            XCTFail()
            return
        }
        // FIXME: "XCTAssertEqual(source, dest)" call neither Card#isEqual: nor "==(_: Card, _: Card) -> Bool".
        XCTAssertTrue(source == dest)
    }

    func testSerializeCardHasIssue() {
        let issueId = GitHubIssueId(owner: "mtgto", repo: "GPM", number: 1)
        let issue = GitHubIssue(id: issueId, type: .Issue, title: "this is issue", body: "this is issue body")
        let source = Card(id: 123, note: nil, issue: issue)
        let data = NSKeyedArchiver.archivedData(withRootObject: source)
        guard let dest = NSKeyedUnarchiver.unarchiveObject(with: data) as? Card else {
            XCTFail()
            return
        }
        // FIXME: "XCTAssertEqual(source, dest)" call neither Card#isEqual: nor "==(_: Card, _: Card) -> Bool".
        XCTAssertTrue(source == dest)
    }
}
