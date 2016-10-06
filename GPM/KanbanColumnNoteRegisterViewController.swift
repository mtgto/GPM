//
//  KanbanColumnNoteRegisterViewController.swift
//  GPM
//
//  Created by mtgto on 2016/10/03.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class KanbanColumnNoteRegisterViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!

    @IBOutlet weak var alertTextField: NSTextField!

    var kanban: Kanban! = nil

    var column: Column! = nil

    weak var columnDelegate: ColumnDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func addNote(_ sender: AnyObject) {
        let service = GitHubService.sharedInstance
        let note = self.textField.stringValue
        self.alertTextField.stringValue = "Adding..."
        service.addProjectCard(owner: kanban.owner, repo: kanban.repo, columnId: column.id, note: note, contentId: nil, contentType: nil) { (response) in
            switch response.result {
            case GitHubResult.Success(let githubCard):
                let card = Card(id: githubCard.id, note: githubCard.note, issue: nil)
                self.columnDelegate.addCard(card)
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
