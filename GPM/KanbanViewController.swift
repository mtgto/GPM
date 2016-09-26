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
    private var kanban: Kanban? = nil
    private var columnCards: [(Column, [Card])] = []

    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.collectionView.register(forDraggedTypes: [NSURLPboardType])
        self.collectionView.setDraggingSourceOperationMask(.every, forLocal: true)
        self.collectionView.setDraggingSourceOperationMask(.every, forLocal: false)
    }

    // MARK: - KanbanDelegate
    func kanbanDidSelected(_ kanban: Kanban) {
        self.kanban = kanban
        KanbanService.sharedInstance.fetchKanban(kanban) { (columnCards) in
            self.columnCards = columnCards
            self.collectionView.reloadData()
        }
    }

    // MARK: - NSCollectionViewDelegate
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        guard let kanban = self.kanban else {
            return nil
        }
        let card = self.columnCards[indexPath.section].1[indexPath.item]
        return GitHubService.sharedInstance.server.webBaseURL.appendingPathComponent("\(kanban.owner)/\(kanban.repo)/projects/\(kanban.number)#card-\(card.id)") as NSURL?
    }

    func collectionView(_ collectionView: NSCollectionView,
                        validateDrop draggingInfo: NSDraggingInfo,
                        proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>,
                        dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        if proposedDropOperation.pointee == NSCollectionViewDropOperation.on {
            proposedDropOperation.pointee = NSCollectionViewDropOperation.before
        }
        proposedDropOperation.pointee = NSCollectionViewDropOperation.before
        // CAUTION: proposedDropIndexPath might be nil (macOS 10.11.6)
        return NSDragOperation.move
    }

    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionViewDropOperation) -> Bool {
        debugPrint("acceptDrop \(indexPath.hashValue)")
        if indexPath.section == 3 {
            return false
        }
        return true
    }

    // MARK: - NSCollectionViewDataSource
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.columnCards.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.columnCards[section].1.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "CardViewItem", for: indexPath)
        item.representedObject = self.columnCards[indexPath.section].1[indexPath.item]
        return item
    }
}
