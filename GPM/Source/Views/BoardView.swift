// SPDX-License-Identifier: MIT

import SwiftUI

// Board Layout for GitHub Project's View
struct BoardView: View {
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
    BoardView()
}
