//
//  SplitViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/19.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let bookmarkViewController = self.splitViewItems[0].viewController as? BookmarkViewController, let kanbanViewController = self.splitViewItems[1].viewController as? KanbanViewController {
            bookmarkViewController.delegate = kanbanViewController
        }
    }
}
