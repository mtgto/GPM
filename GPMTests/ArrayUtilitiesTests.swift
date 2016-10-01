//
//  ArrayUtilitiesTests.swift
//  GPM
//
//  Created by mtgto on 2016/10/01.
//  Copyright © 2016 mtgto. All rights reserved.
//

import XCTest
@testable import GPM

class ArrayUtilitiesTests: XCTestCase {

    func testMoveItems() {
        let array = [0,1,2,3,4,5,6,7,8,9]
        let array2 = array.moveItems(from: IndexSet(arrayLiteral: 0,2,4,6,8), to: 4)
        XCTAssertEqual([1,3,0,2,4,6,8,5,7,9], array2)
    }

}
