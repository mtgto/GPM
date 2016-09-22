//
//  GitHubScope.swift
//  GPM
//
//  Created by mtgto on 2016/09/22.
//  Copyright © 2016 mtgto. All rights reserved.
//

import Cocoa

// All definition is found in https://developer.github.com/v3/oauth/#scopes
public enum GitHubScope: String {
    case User = "user" // also contains "user:email", "user:follow"
    case UserEmail = "user:email"
    case UserFollow = "user:follow"
    case PublicRepo = "public_repo"
    case Repo = "repo"
    case RepoDeployment = "repo_deployment"
    case RepoStatus = "repo:status"
    case DeleteRepo = "delete_repo"
    case Notifications = "notifications"
    case Gist = "gist"
    case ReadRepoHook = "read:repo_hook"
    case WriteRepoHook = "write:repo_hook"
    case AdminRepoHook = "admin:repo_hook"
    case AdminOrgHook = "admin:org_hook"
    case ReadOrg = "read:org"
    case WriteOrg = "write:org"
    case AdminOrg = "admin:org"
    case ReadPublicKey = "read:public_key"
    case WritePublicKey = "write:public_key"
    case AdminPublicKey = "admin:public_key"
    case ReadGpgKey = "read:gpg_key"
    case WriteGpgKey = "write:gpg_key"
    case AdminGpgKey = "admin:gpg_key"
}
