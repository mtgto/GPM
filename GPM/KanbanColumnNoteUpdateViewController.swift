//
//  KanbanColumnNoteUpdateViewController.swift
//  GPM
//
//  Created by mtgto on 2016/10/09.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class KanbanColumnNoteUpdateViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!

    @IBOutlet weak var alertTextField: NSTextField!
    
    var kanban: Kanban! = nil

    var column: Column! = nil

    var card: Card! = nil

    weak var columnDelegate: ColumnDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.textField.stringValue = self.card.note!
    }

    @IBAction func updateNote(_ sender: AnyObject) {
        let service = GitHubService.sharedInstance
        let note = self.textField.stringValue
        self.alertTextField.stringValue = "Updating..."
        service.updateProjectCard(owner: self.kanban.owner, repo: self.kanban.repo, cardId: self.card.id, note: note) { (response) in
            switch response.result {
            case GitHubResult.Success(let githubCard):
                let card = Card(id: githubCard.id, note: githubCard.note, issue: nil)
                self.columnDelegate.updateCard(card)
                self.dismissViewController(self)
                self.removeFromParentViewController()
            case GitHubResult.Failure(let error):
                // show reason
                switch error {
                case .NetworkError:
                    // TODO: l10n
                    self.alertTextField.stringValue = "Invalid URL!"
                case .ParseError:
                    // TODO: l10n
                    self.alertTextField.stringValue = "Unknown error!"
                case .NoTokenError:
                    // TODO: l10n
                    self.alertTextField.stringValue = "Token error!"
                }
            }
        }
    }
}
