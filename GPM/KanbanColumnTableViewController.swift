//
//  KanbanColumnTableViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/27.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class KanbanColumnTableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    var cards: [String] = Array(repeating: "", count: 10)

    static let CardsType = "net.mtgto.GPM.cards"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        cards = cards.enumerated().map({ (offset, element) -> String in
            return String(repeating: "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん", count: offset + 1)
        })
        self.tableView.register(forDraggedTypes: [KanbanColumnTableViewController.CardsType])
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.cards.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.cards[row]
    }

    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        pboard.declareTypes([NSURLPboardType], owner: self)
        let cards = Array(rowIndexes.map { (index) in
            return self.cards[index]
        })
        pboard.setData(NSKeyedArchiver.archivedData(withRootObject: cards), forType: KanbanColumnTableViewController.CardsType)
        return true
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        if dropOperation == .above {
            return .move
        } else {
            return []
        }
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        return false
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        debugPrint("tableView.width = \(tableView.frame.size.width)")
        if let cardCellView = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
            cardCellView.textField?.stringValue = self.cards[row]
            return cardCellView
        } else {
            debugPrint("AAAAAAAAAAAAAAAAAA")
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if let view = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
            view.textField?.stringValue = self.cards[row]
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
