// SPDX-License-Identifier: MIT

import Foundation
import SwiftData

@Model
final class GithubProject: Sendable, Identifiable {
    @Attribute(.unique)
    var id: String
    var number: Int
    var owner: GithubProjectOwner
    var title: String
    var url: String
    @Relationship(deleteRule: .cascade, inverse: \GithubProjectView.project)
    var views: [GithubProjectView]

    init(id: String, number: Int, owner: GithubProjectOwner, title: String, url: String, views: [GithubProjectView]) {
        self.id = id
        self.number = number
        self.owner = owner
        self.title = title
        self.url = url
        self.views = views
    }
}

enum GithubProjectOwner: Codable {
    case organization(login: String)
    case user(login: String)

    var login: String {
        switch self {
        case .organization(login: let login):
            return login
        case .user(login: let login):
            return login
        }
    }
}

@Model final class GithubProjectView: Sendable {
    @Attribute(.unique)
    var id: String
    var name: String
    var varticalFieldName: String
    var project: GithubProject?

    init(id: String, name: String, varticalFieldName: String, project: GithubProject? = nil) {
        self.id = id
        self.name = name
        self.varticalFieldName = varticalFieldName
        self.project = project
    }
}

@Model
final class GithubProjectItem: Sendable {
    @Attribute(.unique)
    var id: String
    var title: String
    var itemType: GithubItemType
    var statusField: GithubProjectItemField?

    init(id: String, title: String, itemType: GithubItemType, statusField: GithubProjectItemField?) {
        self.id = id
        self.title = title
        self.itemType = itemType
        self.statusField = statusField
    }
}

enum GithubItemType: Codable {
    case draftIssue
    case issue(number: Int, repository: String)
    case pullRequest(number: Int, repository: String)
}

struct GithubProjectItemField: Codable {
    var name: String?
    var description: String?
    var color: String
}
