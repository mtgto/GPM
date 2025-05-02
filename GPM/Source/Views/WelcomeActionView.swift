// SPDX-License-Identifier: MIT

import SwiftUI

struct WelcomeActionView: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: 16))
                    .frame(width: 24)
                Text(title)
                Spacer()
            }
            .fontWeight(.medium)
            .frame(height: 36)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    @Previewable var action: () -> () = {}
    WelcomeActionView(iconName: "plus.app", title: "Add Project", action: action)
}
