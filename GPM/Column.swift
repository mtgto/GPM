//
//  Column.swift
//  GPM
//
//  Created by mtgto on 2016/09/19.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

struct Column: Hashable, Equatable {
    let id: Int

    let name: String

    var hashValue: Int {
        return id
    }
}

func == (lhs: Column, rhs: Column) -> Bool {
    return lhs.id == rhs.id
}
