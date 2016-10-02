//
//  Card.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class Card: Hashable, Equatable {
    let id: Int

    let note: String?

    let issue: GitHubIssue?

    var title: String? { return note ?? issue?.title }

    var hashValue: Int {
        return self.id
    }

    init(id: Int, note: String?, issue: GitHubIssue?) {
        self.id = id
        self.note = note
        self.issue = issue
    }
}

func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.id == rhs.id && lhs.note == rhs.note && lhs.issue == rhs.issue
}
