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
    private var columnCards: [(Column, [Card])] = []

    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // MARK: - KanbanDelegate
    func kanbanDidSelected(_ kanban: Kanban) {
        KanbanService.sharedInstance.fetchKanban(kanban) { (columnCards) in
            self.columnCards = columnCards
            self.collectionView.reloadData()
        }
    }

    // MARK: - NSCollectionViewDelegate
    // MARK: - NSCollectionViewDataSource
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        debugPrint("numberOfSections")
        return self.columnCards.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("numberOfItemsInSection:\(section)")
        return self.columnCards[section].1.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        //debugPrint("itemForRepresentedObjectAt:\(indexPath)")
        //debugPrint(collectionView.makeItem(withIdentifier: "CardViewItem", for: indexPath))
        let item = collectionView.makeItem(withIdentifier: "CardViewItem", for: indexPath)
        item.representedObject = self.columnCards[indexPath.section].1[indexPath.item]
        return item
    }
}
