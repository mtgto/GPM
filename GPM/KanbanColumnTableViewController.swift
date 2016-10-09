//
//  KanbanColumnTableViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/27.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

protocol ColumnDelegate: class {
    func addCard(_ card: Card)

    func updateCard(_ newCard: Card)
}

class KanbanColumnTableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, ColumnDelegate {

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

    var kanban: Kanban! = nil

    var column: Column! = nil

    var columnIndex: Int = -1

    var cards: [Card] = []

    static let CardsType = "net.mtgto.GPM.KanbanColumnTableViewController.cards"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tableView.draggingDestinationFeedbackStyle = .gap
        self.tableView.register(forDraggedTypes: [KanbanColumnTableViewController.CardsType])
    }

    /**
     * Remove items from cards parameter and table rows.
     *
     * - rowIndexes: Set of the TableRow.
     */
    func removeAtRowIndexes(_ rowIndexes: IndexSet) -> [Card] {
        let itemIndexes = IndexSet(rowIndexes.map({$0-1}))
        let removed = itemIndexes.map({self.cards[$0]})
        self.tableView.removeRows(at: rowIndexes, withAnimation: NSTableViewAnimationOptions.slideUp)
        self.cards.remove(at: itemIndexes)
        return removed
    }

    @IBAction func addNote(_ sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateController(withIdentifier: "KanbanColumnNoteRegisterViewController") as? KanbanColumnNoteRegisterViewController {
            viewController.kanban = self.kanban
            viewController.column = self.column
            viewController.columnDelegate = self
            debugPrint("self.view.frame: \(self.view.frame), self.view.bounds: \(self.view.bounds), sender.frame: \(sender.frame)")
            self.presentViewController(viewController, asPopoverRelativeTo: self.view.bounds, of: self.view, preferredEdge: NSRectEdge.maxY, behavior: NSPopoverBehavior.transient)
        }
    }

    @IBAction func doubleClicked(_ sender: AnyObject) {
        let clickedRow = self.tableView.clickedRow
        if clickedRow >= 1 {
            let card = self.cards[clickedRow - 1]
            if card.note != nil {
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                if let viewController = storyboard.instantiateController(withIdentifier: "KanbanColumnNoteUpdateViewController") as? KanbanColumnNoteUpdateViewController {
                    viewController.kanban = self.kanban
                    viewController.column = self.column
                    viewController.card = card
                    viewController.columnDelegate = self
                    debugPrint("self.view.frame: \(self.view.frame), self.view.bounds: \(self.view.bounds), sender.frame: \(sender.frame)")
                    self.presentViewController(viewController, asPopoverRelativeTo: self.view.bounds, of: self.view, preferredEdge: NSRectEdge.maxY, behavior: NSPopoverBehavior.transient)
                }
            }
        }
    }

    // MARK: - ColumnDelegate
    func addCard(_ card: Card) {
        self.cards.insert(card, at: 0)
        self.tableView.insertRows(at: IndexSet(integer: 1), withAnimation: .effectGap)
    }

    func updateCard(_ newCard: Card) {
        for (index, card) in self.cards.enumerated() {
            if card.id == newCard.id {
                self.cards[index] = newCard
                self.tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integer: index + 1))
                self.tableView.reloadData(forRowIndexes: IndexSet(integer: index + 1), columnIndexes: IndexSet(integer: 0))
                break
            }
        }
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.cards.count + 1
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if row == 0 {
            return self.column
        } else {
            let cardIndex = row - 1
            return self.cards[cardIndex]
        }
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
        let cardIndex = row - 1
        if let data = pboard.data(forType: KanbanColumnTableViewController.CardsType) {
            if let cardPosition = NSKeyedUnarchiver.unarchiveObject(with: data) as? CardPosition {
                let position = cardIndex == 0 ? GitHubProject.Card.Position.Top : GitHubProject.Card.Position.After(self.cards[cardIndex-1].id)
                if cardPosition.columnIndex == self.columnIndex {
                    // Move from same tableView.
                    self.tableView.beginUpdates()
                    let itemIndexes = IndexSet(cardPosition.rowIndexes.map({$0-1}))
                    let items = self.cards[itemIndexes]
                    self.cards = self.cards.moveItems(from: itemIndexes, to: cardIndex)
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
                    for item in items.reversed() {
                        GitHubService.sharedInstance.updateProjectCardPosition(owner: self.kanban.owner, repo: self.kanban.repo, cardId: item.id, position: position, columnId: nil) { response in
                        }
                    }
                    return true
                } else {
                    // Move from other tableView.
                    self.tableView.beginUpdates()
                    let parentViewController = self.parent as! KanbanViewController
                    let sourceViewController = parentViewController.columnTableViewControllerAtIndex(cardPosition.columnIndex)
                    let items = sourceViewController.removeAtRowIndexes(cardPosition.rowIndexes)
                    self.cards.insert(contentsOf: items, at: cardIndex)
                    let addedRowIndexes = IndexSet(integersIn: row..<row+items.count)
                    self.tableView.insertRows(at: addedRowIndexes, withAnimation: NSTableViewAnimationOptions.slideDown)
                    self.tableView.endUpdates()
                    for item in items.reversed() {
                        GitHubService.sharedInstance.updateProjectCardPosition(owner: self.kanban.owner, repo: self.kanban.repo, cardId: item.id, position: position, columnId: self.column.id) { response in
                            // TODO: error
                            debugPrint("response: \(response)")
                        }
                    }
                    return true
                }
            }
        }
        return false
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //debugPrint("tableView.width = \(tableView.frame.size.width)")
        if row == 0 {
            // header
            if let headerCellView = tableView.make(withIdentifier: "HeaderCellView", owner: self) as? HeaderCellView {
                headerCellView.textField?.stringValue = self.column.name
                return headerCellView
            }
        } else {
            // cards
            let cardIndex = row - 1
            if let cardCellView = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
                cardCellView.textField?.stringValue = self.cards[cardIndex].title!
                return cardCellView
            }
        }
        print("ERROR: no reachable.")
        return nil
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        //debugPrint("heightOfRow:\(row)")
        if row == 0 {
            // header
            if let view = tableView.make(withIdentifier: "HeaderCellView", owner: self) as? HeaderCellView {
                view.textField?.stringValue = self.column!.name
                return view.fittingSize.height
            }
        } else {
            // cards
            let cardIndex = row - 1
            if let view = tableView.make(withIdentifier: "CardCellView", owner: self) as? CardCellView {
                view.textField?.stringValue = self.cards[cardIndex].title!
                //view.textField?.preferredMaxLayoutWidth = 50
                return view.fittingSize.height
            }
        }
        print("ERROR: no reachable.")
        return 0.0
    }

    func tableViewColumnDidResize(_ notification: Notification) {
        debugPrint("tableViewColumnDidResize")
    }
}
