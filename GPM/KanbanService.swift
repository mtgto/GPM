//
//  KanbanService.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

private let KanbansKey: String = "kanbans"

class KanbanService: NSObject {
    static let sharedInstance: KanbanService = KanbanService()

    var kanbans: [Kanban] = []

    override init() {
        super.init()
        let userDefaults = NSUserDefaultsController.shared().defaults
        userDefaults.register(defaults: [KanbansKey: [["owner": "mtgto", "repo": "repo", "number": 1]]])
        if let kanbans = userDefaults.array(forKey: KanbansKey) as? [[String:Any]] {
            self.kanbans = kanbans.map({ (kanbanDict) -> Kanban in
                Kanban(owner: kanbanDict["owner"]! as! String, repo: kanbanDict["repo"] as! String, number: kanbanDict["number"] as! Int)
            })
        }
    }
}
