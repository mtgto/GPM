//
//  KanbanColumnTableViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/27.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class KanbanColumnTableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        debugPrint("BBBBBBBBBBBBBBBBBB")
        return 10
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        debugPrint("CCCCCCCCCCCCCCCCCC")
        return "ああああ \(row)"
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        debugPrint("tableView.width = \(tableView.frame.size.width)")
        if let cardCellView = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
            cardCellView.textField?.stringValue = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"
            return cardCellView
        } else {
            debugPrint("AAAAAAAAAAAAAAAAAA")
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if let view = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
            view.textField?.stringValue = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"
            //view.textField?.preferredMaxLayoutWidth = 50
            return view.fittingSize.height
        } else {
            return 0.0
        }
//        return 76.0
    }

    func tableViewColumnDidResize(_ notification: Notification) {
        debugPrint("tableViewColumnDidResize")
    }
}
