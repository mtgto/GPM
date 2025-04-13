// SPDX-License-Identifier: MIT

import Foundation

/// Response for app requests the device and user verification codes from GitHub
/// https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#step-1-app-requests-the-device-and-user-verification-codes-from-github
struct DeviceFlowStartResponse: Decodable {
    let deviceCode: String
    let userCode: String
    let verificationUri: String
    let expiresIn: Int
    let interval: Int
}

/// Response for polling
/// https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-user-access-token-for-a-github-app#generating-a-user-access-token-when-a-user-installs-your-app
struct DeviceFlowPollResponse: Decodable {
    let accessToken: String
    /// Always be `28800` (8 hours).
    let expiresIn: Int
    let refreshToken: String
    /// Always be `15897600` (6 months).
    let refreshTokenExpiresIn: Int
    let scope: String
    /// Always be `bearer`.
    let tokenType: String
}

struct DeviceFlowClient {
    private static let clientId: String = "Iv23li2yrtFAg5H5hoTp"
    private static let scope: String = "project"

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    enum DeviceFlowError: Error {
        case invalidResponse
    }

    func requestStart() async throws -> DeviceFlowStartResponse {
        let request: URLRequest = {
            var url = URL(string: "https://github.com/login/device/code")?.appending(
                queryItems: [
                    URLQueryItem(name: "client_id", value: Self.clientId),
                    URLQueryItem(name: "scope", value: Self.scope)
                ])
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
            ]
            return request
        }()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DeviceFlowError.invalidResponse
        }
        guard 200 == response.statusCode else {
            throw DeviceFlowError.invalidResponse
        }
        return try decoder.decode(DeviceFlowStartResponse.self, from: data)
    }
}
