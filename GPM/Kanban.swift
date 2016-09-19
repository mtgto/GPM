//
//  Kanban.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class Kanban: Hashable, Equatable {
    let owner: String
    let repo: String
    let number: Int
    var cards: [(GitHubProject.Column, [GitHubProject.Card])] = []

    init(owner: String, repo: String, number: Int) {
        self.owner = owner
        self.repo = repo
        self.number = number
    }

    var hashValue: Int {
        return "\(owner)/\(repo)/\(number)".hashValue
    }
}

func ==(lhs: Kanban, rhs: Kanban) -> Bool {
    return lhs.owner == rhs.owner && lhs.repo == rhs.repo && lhs.number == rhs.number
}
