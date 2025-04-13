//
//  Item.swift
//  GPM
//
//  Created by mtgto on 2025/04/13.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
