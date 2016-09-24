//
//  GitHubProject.swift
//  GPM
//
//  Created by mtgto on 2016/09/17.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

public class GitHubProject: NSObject {
    let number: Int

    let name: String

    let body: String

    public class Column: NSObject {
        let id: Int

        let name: String

        init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }

    public class Card: NSObject {
        public enum Position {
            case Top
            case Bottom
            case After(Int)
        }

        let id: Int

        let note: String?

        let issueId: GitHubIssueId?

        init(id: Int, note: String?, issueId: GitHubIssueId?) {
            self.id = id
            self.note = note
            self.issueId = issueId
        }
    }

    init(number: Int, name: String, body: String) {
        self.number = number
        self.name = name
        self.body = body
    }
}
