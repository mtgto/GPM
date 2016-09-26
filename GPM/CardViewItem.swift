//
//  CardViewItem.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class CardViewItem: NSCollectionViewItem {
    static let width: CGFloat = 230.0
    static let height: CGFloat = 60.0
    static let marginWidth: CGFloat = 10.0
    static let marginHeight: CGFloat = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //self.view.wantsLayer = true
    }

    override func awakeFromNib() {
        self.view.layer?.backgroundColor = NSColor.white.cgColor
    }
}
