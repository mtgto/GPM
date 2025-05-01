// SPDX-License-Identifier: MIT

import Foundation
import Apollo
import ApolloAPI
import KeychainAccess

struct AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    let keychain = Keychain(service: "net.mtgto.gpm")

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        if let accessToken = keychain["GitHubAccessToken"] {
            request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
        }
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion)
    }
}
