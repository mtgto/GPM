// SPDX-License-Identifier: MIT
#if DEBUG

import SwiftData

let sampleStatusFields = [
    GithubProjectStatusField(name: "TODO", fieldDescription: "This item hasn't been started", color: "GREEN", order: 0),
    GithubProjectStatusField(name: "In Progress", fieldDescription: "In Progress", color: "YELLOW", order: 1),
    GithubProjectStatusField(name: "Done", fieldDescription: "This has been completed", color: "PURPLE", order: 2),
]

let sampleProjects = [
    GithubProject(id: "1",
                  number: 1,
                  owner: .user(login: "mtgto"),
                  title: "User Project",
                  url: "https://example.com",
                  statusFields: [
                    GithubProjectStatusField(name: "TODO", fieldDescription: "This item hasn't been started", color: "GREEN", order: 0),
                    GithubProjectStatusField(name: "In Progress", fieldDescription: "In Progress", color: "YELLOW", order: 1),
                    GithubProjectStatusField(name: "Done", fieldDescription: "This has been completed", color: "PURPLE", order: 2),
                  ],
                  views: [
                    GithubProjectView(id: "11", name: "My Board", varticalFieldName: "Status")
                  ],
                  items: [
                    GithubProjectItem(id: "11", title: "TODO Issue", itemType: .draftIssue, statusField: GithubProjectItemField(name: sampleStatusFields[0].name, fieldDescription: sampleStatusFields[0].fieldDescription, color: sampleStatusFields[0].color)),
                    GithubProjectItem(id: "12", title: "Doing Issue", itemType: .issue(number: 123, repository: "dummy"), statusField: GithubProjectItemField(name: sampleStatusFields[1].name, fieldDescription: sampleStatusFields[1].fieldDescription, color: sampleStatusFields[1].color)),
                    GithubProjectItem(id: "13", title: "Done Issue", itemType: .pullRequest(number: 123, repository: "dummy"), statusField: GithubProjectItemField(name: sampleStatusFields[2].name, fieldDescription: sampleStatusFields[2].fieldDescription, color: sampleStatusFields[2].color)),
                    GithubProjectItem(id: "14", title: "TODO Issue 2", itemType: .issue(number: 123, repository: "dummy"), statusField: GithubProjectItemField(name: sampleStatusFields[0].name, fieldDescription: sampleStatusFields[0].fieldDescription, color: sampleStatusFields[0].color)),
                  ]),
    GithubProject(id: "2",
                  number: 2,
                  owner: .organization(login: "example"),
                  title: "Org Project",
                  url: "https://example.com",
                  statusFields: sampleStatusFields,
                  views: [
                    GithubProjectView(id: "21", name: "My Board", varticalFieldName: "Status")
                  ],
                  items: [
                    GithubProjectItem(id: "11", title: "TODO Issue", itemType: .draftIssue, statusField: GithubProjectItemField(name: sampleStatusFields[0].name, fieldDescription: sampleStatusFields[0].fieldDescription, color: sampleStatusFields[0].color)),
                    GithubProjectItem(id: "12", title: "Doing Issue", itemType: .issue(number: 123, repository: "dummy"), statusField: GithubProjectItemField(name: sampleStatusFields[1].name, fieldDescription: sampleStatusFields[1].fieldDescription, color: sampleStatusFields[1].color)),
                    GithubProjectItem(id: "13", title: "Done Issue", itemType: .pullRequest(number: 123, repository: "dummy"), statusField: GithubProjectItemField(name: sampleStatusFields[2].name, fieldDescription: sampleStatusFields[2].fieldDescription, color: sampleStatusFields[2].color)),
                    GithubProjectItem(id: "14", title: "TODO Issue 2", itemType: .issue(number: 123, repository: "dummy"), statusField: GithubProjectItemField(name: sampleStatusFields[0].name, fieldDescription: sampleStatusFields[0].fieldDescription, color: sampleStatusFields[0].color)),
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
