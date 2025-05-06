// SPDX-License-Identifier: MIT

import SwiftUI

struct ProjectView: View {
    let project: GithubProject
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            ForEach(project.views) { view in
                BoardView(project: project)
                    .tabItem {
                        Text(view.name)
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
                project.items = items
                modelContext.insert(project)
                try modelContext.save()
            } catch {
                Logger.standard.error("Failed to fetch items: \(error)")
            }
        }
    }
}

#Preview {
    ProjectView(
        project: sampleProjects[0]
    )
}
