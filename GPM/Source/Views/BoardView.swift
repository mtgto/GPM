// SPDX-License-Identifier: MIT

import SwiftUI

// Board Layout for GitHub Project's View
struct BoardView: View {
    let project: GithubProject

    var body: some View {
        HSplitView {
            ForEach(project.itemsPerStatus, id: \.0) { (statusField, items) in
                VStack {
                    Text(statusField.name)
                    List(items) { item in
                        VStack(alignment: .leading) {
                            if case .draftIssue = item.itemType {
                                Text("Draft")
                                    .font(.subheadline)
                            } else if case .issue(let number, let repository) = item.itemType {
                                Text("Issue \(repository) #\(number)")
                                    .font(.subheadline)
                            } else if case .pullRequest(let number, let repository) = item.itemType {
                                Text("PR \(repository) #\(number)")
                                    .font(.subheadline)
                            }
                            Text(item.title)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BoardView(project: sampleProjects[0])
}
