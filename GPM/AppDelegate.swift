//
//  AppDelegate.swift
//  GPM
//
//  Created by mtgto on 2016/09/17.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let accessToken = AccessTokenService.sharedInstance.accessToken() {
            GitHubService.sharedInstance.accessToken = accessToken
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

