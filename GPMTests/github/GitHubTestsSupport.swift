//
//  GitHubTestsSupport.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import XCTest

protocol GitHubTestsSupport {
    func dataFromResourceFile(_ filename: String) -> Data
}

extension GitHubTestsSupport where Self: XCTestCase {
    func URLForResourceFile(_ filename: String) -> URL {
        let baseName = (filename as NSString).deletingPathExtension
        let ext = (filename as NSString).pathExtension
        let url = Bundle(for: type(of: self)).url(forResource: baseName, withExtension: ext)
        XCTAssertNotNil(url, "Resource file is not found")
        return url!
    }

    func dataFromResourceFile(_ filename: String) -> Data {
        let data = try? Data(contentsOf: self.URLForResourceFile(filename))
        XCTAssertNotNil(data, "Failed to load resource from filename \"\(filename)\"")
        return data!
    }
}
