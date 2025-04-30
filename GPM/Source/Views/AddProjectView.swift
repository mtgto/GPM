// SPDX-License-Identifier: MIT

import SwiftUI

struct AddProjectView: View {
    @Binding var showing: Bool
    @Binding var urlString: String
    @State private var project: (owner: GithubProjectOwner, number: Int)?
    static let projectUrlPattern = /^https:\/\/github\.com\/(orgs|users)\/([^\/]+)\/projects\/(\d+)/

    var body: some View {
        VStack {
            Form {
                TextField("Project URL", text: $urlString)
                    .onChange(of: urlString) { _, urlString in
                        if let match = try? Self.projectUrlPattern.firstMatch(in: urlString), let number = Int(match.3) {
                            if match.1 == "orgs" {
                                project = (owner: .organization(login: String(match.2)), number: number)
                            } else if match.1 == "users" {
                                project = (owner: .user(login: String(match.2)), number: number)
                            }
                        }
                    }
            }.formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    showing = false
                }
                Button {
                    // TODO: Fetch a project by using GitHub API & Add a project to SwiftData
                    showing = false
                } label: {
                    Text("Done")
                }
                .keyboardShortcut(.defaultAction)
                .disabled(urlString.isEmpty)
                .padding([.trailing, .bottom, .top])
            }
            Spacer()
        }
    }
}

#Preview {
    AddProjectView(
        showing: .constant(true),
        urlString: .constant("https://github.com/users/mtgto/projects/1"),
    )
}
