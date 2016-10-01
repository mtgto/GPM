//
//  KanbanColumnTableViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/27.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class KanbanColumnTableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    class CardPosition: NSObject, NSCoding {
        let columnIndex: Int
        let rowIndexes: IndexSet

        init(columnIndex: Int, rowIndexes: IndexSet) {
            self.columnIndex = columnIndex
            self.rowIndexes = rowIndexes
        }

        // MARK: - NSCoding
        required init?(coder aDecoder: NSCoder) {
            self.columnIndex = aDecoder.decodeInteger(forKey: "columnIndex")
            self.rowIndexes = aDecoder.decodeObject(forKey: "rowIndexes") as! IndexSet
        }

        func encode(with aCoder: NSCoder) {
            aCoder.encode(self.columnIndex, forKey: "columnIndex")
            aCoder.encode(self.rowIndexes, forKey: "rowIndexes")
        }
    }

    @IBOutlet weak var tableView: NSTableView!

    var columnIndex: Int = -1

    var cards: [String] = Array(repeating: "", count: 10)

    static let CardsType = "net.mtgto.GPM.KanbanColumnTableViewController.cards"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        cards = cards.enumerated().map({ (offset, element) -> String in
            return String(repeating: "\(offset),\(self.columnIndex) あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん", count: offset + 1)
        })
        self.tableView.draggingDestinationFeedbackStyle = .gap
        self.tableView.register(forDraggedTypes: [KanbanColumnTableViewController.CardsType])
    }

    func removeAtIndexSet(_ indexSet: IndexSet) -> [String] {
        let removed = indexSet.map({self.cards[$0]})
        self.tableView.removeRows(at: indexSet, withAnimation: NSTableViewAnimationOptions.slideUp)
        self.cards.remove(at: indexSet)
        return removed
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.cards.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.cards[row]
    }

    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        pboard.declareTypes([KanbanColumnTableViewController.CardsType], owner: nil)
        pboard.setData(NSKeyedArchiver.archivedData(withRootObject: CardPosition(columnIndex: self.columnIndex, rowIndexes: rowIndexes)), forType: KanbanColumnTableViewController.CardsType)
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
        let pboard = info.draggingPasteboard()
        if let data = pboard.data(forType: KanbanColumnTableViewController.CardsType) {
            if let cardPosition = NSKeyedUnarchiver.unarchiveObject(with: data) as? CardPosition {
                if cardPosition.columnIndex == self.columnIndex {
                    // Move from same tableView.
                    self.tableView.beginUpdates()
                    self.cards = self.cards.moveItems(from: cardPosition.rowIndexes, to: row)
                    var oldOffset = 0
                    var newOffset = 0
                    for index in Array(cardPosition.rowIndexes).sorted().reversed() {
                        if index < row {
                            self.tableView.moveRow(at: index + oldOffset, to: row - 1)
                            oldOffset -= 1
                        } else {
                            self.tableView.moveRow(at: index, to: row + newOffset)
                            newOffset += 1
                        }
                    }
                    self.tableView.endUpdates()
                    return true
                } else {
                    // Move from other tableView.
                    self.tableView.beginUpdates()
                    if let parentViewController = self.parent as? KanbanViewController {
                        let sourceViewController = parentViewController.columnTableViewControllerAtIndex(cardPosition.columnIndex)
                        let items = sourceViewController.removeAtIndexSet(cardPosition.rowIndexes)
                        self.cards.insert(contentsOf: items, at: row)
                        let addedIndexSet = IndexSet(integersIn: row..<row+items.count)
                        self.tableView.insertRows(at: addedIndexSet, withAnimation: NSTableViewAnimationOptions.slideDown)
                    }
                    self.tableView.endUpdates()
                    return true
                }
            }
        }
        return false
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //debugPrint("tableView.width = \(tableView.frame.size.width)")
        if let cardCellView = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
            cardCellView.textField?.stringValue = self.cards[row]
            return cardCellView
        } else {
            debugPrint("AAAAAAAAAAAAAAAAAA")
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        //debugPrint("heightOfRow:\(row)")
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
