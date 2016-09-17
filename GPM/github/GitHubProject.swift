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
        let name: String

        init(name: String) {
            self.name = name
        }
    }

    init(number: Int, name: String, body: String) {
        self.number = number
        self.name = name
        self.body = body
    }
}
