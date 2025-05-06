// SPDX-License-Identifier: MIT

import SwiftUI

struct ProjectView: View {
    let project: GithubProject

    var body: some View {
        TabView {
            ForEach(project.views) { project in
                BoardView()
                    .tabItem {
                        Text(project.name)
                    }
            }
        }
        .task {
            // Fetch items of project
            let client = GithubClient()
            do {
                let items = try await client.projectItems(owner: project.owner, number: project.number)
                items.forEach { item in
                    Logger.standard.info("Item: \(item.title)")
                }
            } catch {
                Logger.standard.error("Failed to fetch items: \(error)")
            }
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
