//
//  GitHubIssue.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

public class GitHubIssue: NSObject {
    let number: Int

    let title: String

    let body: String //! markdown

    init(number: Int, title: String, body: String) {
        self.number = number
        self.title = title
        self.body = body
    }
}
