//
//  Array+Utilities.swift
//  GPM
//
//  Created by mtgto on 2016/10/01.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Foundation

extension Array {
    /**
     * Move items to the new position.
     */
    func moveItems(from indexSet: IndexSet, to position: Int) -> [Element] {
        var left: [Element] = []
        var right: [Element] = []
        var center: [Element] = []
        self.enumerated().forEach { (offset, element) in
            if indexSet.contains(offset) {
                center.append(element)
            } else if offset < position {
                left.append(element)
            } else {
                right.append(element)
            }
        }
        return left + center + right
    }
}
