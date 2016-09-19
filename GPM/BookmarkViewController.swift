//
//  BookmarkViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class BookmarkViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var delegate: KanbanDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.make(withIdentifier: "BookmarkViewCell", owner: tableView)
        if let cell = view as? NSTableCellView {
            cell.textField?.stringValue = KanbanService.sharedInstance.kanbans[row].repo
            return cell
        } else {
            debugPrint(view)
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView {
            let kanban = KanbanService.sharedInstance.kanbans[tableView.selectedRow]
            self.delegate?.kanbanDidSelected(kanban)
        }
    }

    // MARK: - NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        debugPrint("COUNT: \(KanbanService.sharedInstance.kanbans.count)")
        return KanbanService.sharedInstance.kanbans.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return KanbanService.sharedInstance.kanbans[row]
    }
}
