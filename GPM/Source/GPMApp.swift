// SPDX-License-Identifier: MIT

import SwiftUI
import SwiftData

@main
struct GPMApp: App {
    let store = Store()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GithubProject.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
        .windowStyle(.hiddenTitleBar)
        .modelContainer(sharedModelContainer)
        .environment(store)

        WindowGroup(id: "project", for: String.self) { $id in
            if let id, let project = getProjectById(id) {
                ProjectView(project: project)
                    .navigationTitle(project.title)
            } else {
                EmptyView()
            }
        }
    }

    func getProjectById(_ id: String) -> GithubProject? {
        let predicate = #Predicate<GithubProject> { $0.id == id }
        do {
            return try sharedModelContainer.mainContext.fetch(FetchDescriptor(predicate: predicate)).first
        } catch {
            return nil
        }
    }
}
