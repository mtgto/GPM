// SPDX-License-Identifier: MIT

import SwiftUI

struct ProjectView: View {
    var body: some View {
        HSplitView {
            Rectangle()
                .fill(Color.red)
            Rectangle()
                .fill(Color.green)
            Rectangle()
                .fill(Color.blue)
        }
    }
}

#Preview {
    ProjectView()
}
