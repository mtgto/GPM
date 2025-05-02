// SPDX-License-Identifier: MIT

import SwiftUI

struct OpenProjectView: View {
    @State private var urlString: String = ""
    @Binding var project: (owner: GithubProjectOwner, number: Int)?
    @Binding var editing: Bool
    @State var currentProject: (owner: GithubProjectOwner, number: Int)?
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
                    let client = GithubClient()
                    project = currentProject
                    editing = false
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
