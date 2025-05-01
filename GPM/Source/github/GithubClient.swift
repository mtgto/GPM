// SPDX-License-Identifier: MIT

import Foundation
import API
import Apollo
import ApolloAPI

struct GithubClient {
    struct AccessTokenResponse: Decodable {
        let accessToken: String
        let expiresIn: Int
        let refreshToken: String
        let refreshTokenExpiresIn: Int
        let scope: String
        let tokenType: String
    }

    enum AccessTokenError: Error {
        case invalidResponse
    }

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func generateAccessToken(clientId: String, clientSecret: String, code: String) async throws -> AccessTokenResponse {
        let request: URLRequest = {
            let url = URL(string: "https://github.com/login/oauth/access_token")?.appending(
                queryItems: [
                    URLQueryItem(name: "client_id", value: clientId),
                    URLQueryItem(name: "client_secret", value: clientSecret),
                    URLQueryItem(name: "code", value: code),
                    URLQueryItem(name: "redirect_uri", value: "net.mtgto.gpm://callback"),
                ])
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
            ]
            return request
        }()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let _ = response as? HTTPURLResponse else {
            throw AccessTokenError.invalidResponse
        }
        return try decoder.decode(AccessTokenResponse.self, from: data)
    }

    func generateAccessToken(clientId: String, clientSecret: String, refreshToken: String) async throws -> AccessTokenResponse {
        let request: URLRequest = {
            let url = URL(string: "https://github.com/login/oauth/access_token")?.appending(
                queryItems: [
                    URLQueryItem(name: "client_id", value: clientId),
                    URLQueryItem(name: "client_secret", value: clientSecret),
                    URLQueryItem(name: "grant_type", value: "refresh_token"),
                    URLQueryItem(name: "refresh_token", value: refreshToken),
                ])
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
            ]
            return request
        }()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let _ = response as? HTTPURLResponse else {
            throw AccessTokenError.invalidResponse
        }
        return try decoder.decode(AccessTokenResponse.self, from: data)
    }

    func me() async throws -> String {
        let apolloClient = setupApolloClient()
        let result = try await apolloClient.fetch(query: API.MeQuery())
        return result.viewer.login
    }

    func setupApolloClient() -> ApolloClient {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: "https://api.github.com/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }
}
