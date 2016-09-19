//
//  KanbanService.swift
//  GPM
//
//  Created by mtgto on 2016/09/18.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa
import Alamofire

private let KanbansKey: String = "kanbans"

class KanbanService: NSObject {
    static let sharedInstance: KanbanService = KanbanService()

    var kanbans: [Kanban] = []

    override init() {
        super.init()
        let userDefaults = NSUserDefaultsController.shared().defaults
        userDefaults.register(defaults: [KanbansKey: [["owner": "mtgto", "repo": "GPM", "number": 1]]])
        if let kanbans = userDefaults.array(forKey: KanbansKey) as? [[String:Any]] {
            self.kanbans = kanbans.map({ (kanbanDict) -> Kanban in
                Kanban(owner: kanbanDict["owner"]! as! String, repo: kanbanDict["repo"] as! String, number: kanbanDict["number"] as! Int)
            })
        }
    }

    func fetchKanban(_ kanban: Kanban, handler: @escaping ([(Column, [Card])]) -> Void) {
        debugPrint("Start to fetch kanban: \(kanban).")
        var cards: [(Column, [Card])] = []
        let group = DispatchGroup()

        group.enter()
        GitHubService.sharedInstance.fetchProjectColumnsForProject(owner: kanban.owner, repo: kanban.repo, projectNumber: kanban.number) { (response) in
            switch response {
            case GitHubResponse.Success(let githubColumns):
                debugPrint("Succeeded to fetch columns: \(githubColumns)")
                let columns = githubColumns.map({Column(id: $0.id, name: $0.name)})
                cards = columns.map { ($0, []) }
                for column in columns {
                    group.enter()
                    GitHubService.sharedInstance.fetchProjectCardsForProjectColumn(owner: kanban.owner, repo: kanban.repo, columnId: column.id) { (response) in
                        switch response {
                        case GitHubResponse.Success(let githubCards):
                            debugPrint("Succeeded to fetch cards: \(githubCards)")
                            group.enter()
                            self.fetchIssues(cards: githubCards, handler: { (cardIssues) in
                                cards = cards.map({ (columnCards: (Column, [Card])) -> (Column, [Card]) in
                                    if column == columnCards.0 {
                                        return (column, cardIssues.map({Card(id: $0.0.id, note: $0.0.note, issue: $0.1)}))
                                    } else {
                                        return columnCards
                                    }
                                })
                                group.leave()
                            })
                        case GitHubResponse.Failure(let error):
                            print(error)
                        }
                        group.leave()
                    }
                }
            case GitHubResponse.Failure(let error):
                print(error)
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) { 
            debugPrint("All download done. \(cards)")
            handler(cards)
        }
    }

    func fetchIssues(cards: [GitHubProject.Card], handler: @escaping (([(GitHubProject.Card, GitHubIssue?)]) -> Void)) {
        func loop(cards: [GitHubProject.Card], current: [(GitHubProject.Card, GitHubIssue?)]) {
            if cards.count == 0 {
                handler(current)
            } else {
                let card = cards[0]
                let last: [GitHubProject.Card] = Array(cards.dropFirst(1))
                if let issueId = card.issueId {
                    GitHubService.sharedInstance.fetchIssue(owner: issueId.owner, repo: issueId.repo, number: issueId.number) { (response) in
                        switch response {
                        case GitHubResponse.Success(let issue):
                            loop(cards: last, current: current + [(card, issue)])
                        case GitHubResponse.Failure(let error):
                            print(error)
                            loop(cards: last, current: current + [(card, nil)])
                        }
                    }
                } else {
                    loop(cards: last, current: current + [(card, nil)])
                }
            }
        }
        loop(cards: cards, current: [])
    }
}
