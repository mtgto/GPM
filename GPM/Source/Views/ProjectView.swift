// SPDX-License-Identifier: MIT

import SwiftUI

struct ProjectView: View {
    let project: GithubProject

    var body: some View {
        HSplitView {
            Rectangle()
                .fill(Color.red)
            Rectangle()
                .fill(Color.green)
            Rectangle()
                .fill(Color.blue)
        }
    }
}

#Preview {
    ProjectView(
        project: GithubProject(id: "1", number: 1, owner: .user(login: "mtgto"), title: "Example Project", url: "https://example.com", views: [
            GithubProjectView(id: "1", name: "My Board", varticalFieldName: "Status")
        ])
    )
}
