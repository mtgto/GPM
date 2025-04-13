// SPDX-License-Identifier: MIT

import SwiftUI

struct AuthorizeView: View {
    var body: some View {
        @State var isStarting = false

        VStack {
            Text("GitHub Projectの情報の取得・操作のためにGitHub Appをインストールします。Authorizeをクリックすると続行します")
                .multilineTextAlignment(.center)
            Button {
                let deviceFlowClient = DeviceFlowClient()
                isStarting = true
                Task {
                    do {
                        let response = try await deviceFlowClient.requestStart()
                        debugPrint(response)
                    } catch {
                        debugPrint("Failed to start device flow: \(error)")
                    }
                    isStarting = false
                }
            } label: {
                Text("Authorize")
            }
        }
        .padding()
    }
}

#Preview {
    AuthorizeView()
}
