//
//  KanbanViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

protocol KanbanDelegate {
    func kanbanDidSelected(_ kanban: Kanban)
}

class KanbanViewController: NSViewController, KanbanDelegate {
    private var kanban: Kanban? = nil
    private var columnCards: [(Column, [Card])] = []

    @IBOutlet weak var stackView: NSStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // MARK: - KanbanDelegate
    func kanbanDidSelected(_ kanban: Kanban) {
        self.kanban = kanban
        self.childViewControllers.forEach({ viewController in
            self.stackView.removeView(viewController.view)
            viewController.removeFromParentViewController()
        })
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
//        KanbanService.sharedInstance.fetchKanban(kanban) { (columnCards) in
//            self.columnCards = columnCards
//            //self.collectionView.reloadData()
//            for _ in columnCards {
//                if let viewController = storyboard.instantiateController(withIdentifier: "KanbanColumnTableViewController") as? KanbanColumnTableViewController {
//                    self.stackView.addArrangedSubview(viewController.view)
//                }
//            }
//        }
        for columnIndex in 1...3 {
            if let viewController = storyboard.instantiateController(withIdentifier: "KanbanColumnTableViewController") as? KanbanColumnTableViewController {
                viewController.columnIndex = columnIndex
                self.addChildViewController(viewController)
                self.stackView.addArrangedSubview(viewController.view)
            }
        }
    }

    func tableViewColumnDidResize(_ notification: Notification) {
        debugPrint("tableViewColumnDidResize")
    }
}
