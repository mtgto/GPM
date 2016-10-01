//
//  Card.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class Card: NSObject, NSCoding, NSPasteboardWriting, NSPasteboardReading {
    static let UTI = "net.mtgto.GPM.card"

    let id: Int

    let note: String?

    let issue: GitHubIssue?

    var title: String? { return note ?? issue?.title }

    init(id: Int, note: String?, issue: GitHubIssue?) {
        self.id = id
        self.note = note
        self.issue = issue
    }

    // MARK: - NSPasteboardReading
    required init?(pasteboardPropertyList propertyList: Any, ofType type: String) {
//        if type == Card.UTI {
//            if let plistData = propertyList as? Data, let unArchive = NSKeyedUnarchiver(forReadingWith: plistData).decodeObject(forKey: Card.UTI) as? IndexSet {
//                self.init(indexSet: unArchive)
//                return
//            }
//        }

        return nil
    }

    static func readableTypes(for pasteboard: NSPasteboard) -> [String] {
        return [Card.UTI]
    }

    static func readingOptions(forType type: String, pasteboard: NSPasteboard) -> NSPasteboardReadingOptions {
        return .asKeyedArchive
    }

    // MARK: - NSPasteboardWriting
    func writableTypes(for pasteboard: NSPasteboard) -> [String] {
        return [Card.UTI]
    }

    func pasteboardPropertyList(forType type: String) -> Any? {
        guard type == Card.UTI else {
            return nil
        }
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.note = aDecoder.decodeObject(forKey: "note") as? String
        self.issue = aDecoder.decodeObject(forKey: "issue") as? GitHubIssue
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        if let note = self.note {
            aCoder.encode(note, forKey: "note")
        }
        if let issue = self.issue {
            aCoder.encode(issue, forKey: "issue")
        }
    }

    // MARK: - Equatable (NSObject)
    override func isEqual(to object: Any?) -> Bool {
        if let card = object as? Card {
            return self.id == card.id && self.note == card.note && self.issue == card.issue
        } else {
            return false
        }
    }
}

func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.id == rhs.id && lhs.note == rhs.note && lhs.issue == rhs.issue
}
