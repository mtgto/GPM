// SPDX-License-Identifier: MIT

import Foundation
import Apollo
import ApolloAPI

enum GithubGraphqlError: Error {
    case errors([GraphQLError])
    case noData
}

extension ApolloClient {
    public func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main
    ) async throws -> Query.Data {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(
                query: query,
                cachePolicy: cachePolicy,
                contextIdentifier: contextIdentifier,
                queue: queue
            ) { result in
                do {
                    let result = try result.get()
                    if let errors = result.errors {
                        continuation.resume(throwing: GithubGraphqlError.errors(errors))
                    } else if let data = result.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: GithubGraphqlError.noData)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
