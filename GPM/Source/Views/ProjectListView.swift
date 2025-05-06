// SPDX-License-Identifier: MIT

import SwiftUI
import SwiftData

struct ProjectListView: View {
    @Query private var projects: [GithubProject]
    @State private var selectedProject: GithubProject?
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        List(projects, id: \.self, selection: $selectedProject) { project in
            VStack(alignment: .leading) {
                Text(project.title)
                    .font(.title3)
                Text("\(project.owner.login)/\(project.number)")
                    .font(.subheadline)
            }
        }
        .contextMenu(forSelectionType: GithubProject.self, menu: { _ in }) { projects in
            if let project = projects.first {
                openWindow(id: "project", value: project.id)
            }
        }
    }
}

#Preview {
    ProjectListView()
        .modelContainer(previewContainer)
}
