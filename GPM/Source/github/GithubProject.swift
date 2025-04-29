// SPDX-License-Identifier: MIT

import Foundation
import SwiftData

@Model
final class GithubProject {
    @Attribute(.unique)
    var id: String
    var number: Int
    var owner: GithubProjectOwner
    var title: String

    init(id: String, number: Int, owner: GithubProjectOwner, title: String) {
        self.id = id
        self.number = number
        self.owner = owner
        self.title = title
    }
}

enum GithubProjectOwner: Codable {
    case organization(login: String)
    case user(login: String)
}
