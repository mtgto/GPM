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
        public enum ContentType: String {
            case Issue = "Issue"
            case PullRequest = "PullRequest"
        }

        let contentId: Int

        let note: String

        init(contentId: Int, note: String) {
            self.contentId = contentId
            self.note = note
        }
    }

    init(number: Int, name: String, body: String) {
        self.number = number
        self.name = name
        self.body = body
    }
}
