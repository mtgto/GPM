// SPDX-License-Identifier: MIT

import SwiftUI

struct OpenProjectView: View {
    @State private var urlString: String = ""
    @Binding var project: (owner: GithubProjectOwner, number: Int)?
    @Binding var editing: Bool
    @State var currentProject: (owner: GithubProjectOwner, number: Int)?
    @Environment(\.modelContext) private var modelContext
    static let projectUrlPattern = /^https:\/\/github\.com\/(orgs|users)\/([^\/]+)\/projects\/(\d+)/

    var body: some View {
        VStack(alignment: .leading) {
            Section("Enter the URL of the GitHub Project to open:") {
                TextField("Project URL", text: $urlString)
                    .onChange(of: urlString) { _, urlString in
                        if let match = try? Self.projectUrlPattern.firstMatch(in: urlString), let number = Int(match.3) {
                            if match.1 == "orgs" {
                                currentProject = (owner: .organization(login: String(match.2)), number: number)
                            } else if match.1 == "users" {
                                currentProject = (owner: .user(login: String(match.2)), number: number)
                            }
                        }
                    }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    editing = false
                }
                Button("Open Project") {
                    // TODO: Fetch a project by using GitHub API & Add a project to SwiftData
                    if let currentProject {
                        let client = GithubClient()
                        Task {
                            guard let projectOverview = try await client.projectOverview(owner: currentProject.owner, number: currentProject.number) else {
                                // TODO: Show error message
                                Logger.standard.error("Error: Failed to fetch project overview")
                                return
                            }
                            let newProject = GithubProject(id: projectOverview.id,
                                                           number: currentProject.number,
                                                           owner: currentProject.owner,
                                                           title: projectOverview.title)
                            modelContext.insert(newProject)
                            project = currentProject
                            editing = false
                        }
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(currentProject == nil)
            }
        }
        .padding()
    }
}

#Preview {
    OpenProjectView(project: .constant(nil), editing: .constant(true))
}
