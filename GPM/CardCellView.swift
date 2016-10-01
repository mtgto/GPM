//
//  CardCellView.swift
//  GPM
//
//  Created by mtgto on 2016/09/27.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class CardCellView: NSTableCellView {

    @IBOutlet weak var additionalTextField: NSTextField!

    override func awakeFromNib() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.layer?.cornerRadius = 4.0
        self.layer?.borderWidth = 1.0
        self.layer?.borderColor = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
