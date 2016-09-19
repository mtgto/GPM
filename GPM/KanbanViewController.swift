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

class KanbanViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, KanbanDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // MARK: - KanbanDelegate
    func kanbanDidSelected(_ kanban: Kanban) {
        KanbanService.sharedInstance.fetchKanban(kanban)
    }

    // MARK: - NSCollectionViewDelegate
    // MARK: - NSCollectionViewDataSource
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        debugPrint("numberOfSections")
        return 2
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("numberOfItemsInSection:\(section)")
        return 10
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        debugPrint("itemForRepresentedObjectAt:\(indexPath)")
        //debugPrint(collectionView.makeItem(withIdentifier: "CardViewItem", for: indexPath))
        let item = collectionView.makeItem(withIdentifier: "CardViewItem", for: indexPath)
        item.representedObject = Card(id: indexPath.item, note: "title \(indexPath.section),\(indexPath.item)", issue: nil)
        return item
    }
}
