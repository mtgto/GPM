//
//  KanbanCollectionViewLayout.swift
//  GPM
//
//  Created by mtgto on 2016/09/19.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class KanbanCollectionViewLayout: NSCollectionViewLayout {
    override var collectionViewContentSize: NSSize {
        if let collectionView = self.collectionView {
            let columns = collectionView.numberOfSections
            let rows = (0..<columns).map({collectionView.numberOfItems(inSection: $0)}).max() ?? 0
            let width = CardViewItem.width * CGFloat(columns)
            let height = CardViewItem.height * CGFloat(rows)
            // TODO: Support header size.
            return NSSize(width: width, height: height)
        } else {
            return NSSize.zero
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        // TODO: refactor
        return true
    }

    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        // TODO: refactor
        var attributes = [NSCollectionViewLayoutAttributes]()
        if let collectionView = self.collectionView {
            for section in 0..<collectionView.numberOfSections {
                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    if let attribute = layoutAttributesForItem(at: NSIndexPath(forItem: item, inSection: section) as IndexPath) {
                        attributes.append(attribute)
                    }
                }
            }
        }
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
        attributes.frame = NSRect(x: CardViewItem.width * CGFloat(indexPath.section), y: CardViewItem.height * CGFloat(indexPath.item), width: CardViewItem.width, height: CardViewItem.height)
        attributes.zIndex = indexPath.item
        return attributes
    }
}
