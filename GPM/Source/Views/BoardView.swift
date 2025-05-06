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
                        Text(item.title)
                    }
                }
            }
        }
    }
}

#Preview {
    BoardView(project: sampleProjects[0])
}
