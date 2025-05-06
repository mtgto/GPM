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
    @Relationship(deleteRule: .cascade, inverse: \GithubProjectStatusField.project)
    var statusFields: [GithubProjectStatusField]
    @Relationship(deleteRule: .cascade, inverse: \GithubProjectView.project)
    var views: [GithubProjectView]
    @Relationship(deleteRule: .cascade, inverse: \GithubProjectItem.project)
    var items: [GithubProjectItem]

    init(id: String, number: Int, owner: GithubProjectOwner, title: String, url: String, statusFields: [GithubProjectStatusField], views: [GithubProjectView], items: [GithubProjectItem]) {
        self.id = id
        self.number = number
        self.owner = owner
        self.title = title
        self.url = url
        self.statusFields = statusFields
        self.views = views
        self.items = items
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

@Model
final class GithubProjectView: Sendable {
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
final class GithubProjectStatusField: Sendable {
    var name: String
    var fieldDescription: String
    var color: String
    var order: Int
    var project: GithubProject?

    init(name: String, fieldDescription: String, color: String, order: Int, project: GithubProject? = nil) {
        self.name = name
        self.fieldDescription = fieldDescription
        self.color = color
        self.order = order
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
    var project: GithubProject?

    init(id: String, title: String, itemType: GithubItemType, statusField: GithubProjectItemField?, project: GithubProject? = nil) {
        self.id = id
        self.title = title
        self.itemType = itemType
        self.statusField = statusField
        self.project = project
    }
}

enum GithubItemType: Codable {
    case draftIssue
    case issue(number: Int, repository: String)
    case pullRequest(number: Int, repository: String)
}

struct GithubProjectItemField: Codable {
    var name: String?
    var fieldDescription: String?
    var color: String
}
