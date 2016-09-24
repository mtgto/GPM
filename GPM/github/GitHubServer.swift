//
//  GitHubServer.swift
//  GPM
//
//  Created by mtgto on 2016/09/24.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Foundation

struct GitHubServer {
    /**
     * API endpoint URL. This url must end with a slash.
     *
     * example: https://api.github.com/
     */
    let apiBaseURL: NSURL

    /**
     * Web front URL. This url must end with a slash.
     *
     * example: https://github.com/
     */
    let webBaseURL: NSURL
}
