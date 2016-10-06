//
//  LoginViewController.swift
//  GPM
//
//  Created by mtgto on 2016/09/22.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var tokenTextField: NSTextField!
    @IBOutlet weak var alertTextField: NSTextField!
    @IBOutlet weak var okButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // Notified while live editing.
    override func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            okButton.isEnabled = !textField.stringValue.isEmpty
        }
    }

    @IBAction func addAccessToken(_ sender: AnyObject) {
        self.alertTextField.stringValue = "Checking the access token..."
        let accessToken = self.tokenTextField.stringValue
        let service = GitHubService()
        service.accessToken = accessToken
        service.fetchUser { (response) in
            switch response.result {
            case GitHubResult.Success(_):
                if response.scopes.contains(GitHubScope.PublicRepo.rawValue) || response.scopes.contains(GitHubScope.Repo.rawValue) {
                    AccessTokenService.sharedInstance.setAccessToken(accessToken)
                    GitHubService.sharedInstance.accessToken = accessToken
                    self.dismissViewController(self)
                } else {
                    // TODO: l10n
                    self.alertTextField.stringValue = "This token doesn't have repo or public_repo scope."
                }
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
                    self.alertTextField.stringValue = "Unknown error!"
                }
            }
        }
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        self.dismissViewController(self)
        NSRunningApplication.current().terminate()
    }
}
