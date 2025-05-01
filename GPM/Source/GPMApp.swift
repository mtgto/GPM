// SPDX-License-Identifier: MIT

import SwiftUI
import SwiftData

@main
struct GPMApp: App {
    let store = Store()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            ContentView()
                .environment(store)
        }
        .modelContainer(sharedModelContainer)
        .environment(store)

        Window("Authorize", id: "authorize") {
            AuthorizeView()
                .environment(store)
        }
    }
}
