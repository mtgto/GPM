// SPDX-License-Identifier: MIT

import SwiftUI

// Board Layout for GitHub Project's View
struct BoardView: View {
    let project: GithubProject

    var body: some View {
        HSplitView {
            ForEach(project.statusFields) { statusField in
                VStack {
                    Text(statusField.name)
                    Rectangle()
                }
            }
        }
    }
}

#Preview {
    BoardView(project: sampleProjects[0])
}
