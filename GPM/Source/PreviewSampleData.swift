// SPDX-License-Identifier: MIT
#if DEBUG

import SwiftData

let sampleProjects = [
    GithubProject(id: "1", number: 1, owner: .user(login: "mtgto"), title: "User Project", url: "https://example.com", views: [
        GithubProjectView(id: "11", name: "My Board", varticalFieldName: "Status")
    ]),
    GithubProject(id: "2", number: 2, owner: .organization(login: "example"), title: "Org Project", url: "https://example.com", views: [
        GithubProjectView(id: "21", name: "My Board", varticalFieldName: "Status")
    ]),
]

@MainActor
let previewContainer = {
    do {
        let container = try ModelContainer(
            for: GithubProject.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<GithubProject>()).isEmpty {
            sampleProjects.forEach { container.mainContext.insert($0) }
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
#endif
