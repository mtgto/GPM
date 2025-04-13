// SPDX-License-Identifier: MIT

import SwiftUI

struct AuthorizeView: View {
    @State var isStarting = false
    @State var didFailed = false

    var body: some View {
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
                        didFailed = true
                    }
                    isStarting = false
                }
            } label: {
                Text("Authorize")
            }
            .alert("Error", isPresented: $didFailed) {

            } message: {
                Text("Failed to start authorization")
            }
        }
        .padding()
    }
}

#Preview {
    AuthorizeView()
}
