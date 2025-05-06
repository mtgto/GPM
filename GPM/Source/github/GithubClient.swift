// SPDX-License-Identifier: MIT

import Foundation
import API
import Apollo
import ApolloAPI

struct GithubClient {
    // For GitHub App
    struct GitHubAppAccessTokenResponse: Decodable {
        let accessToken: String
        let expiresIn: Int
        let refreshToken: String
        let refreshTokenExpiresIn: Int
        let scope: String
        let tokenType: String
    }

    // For OAuth2 App
    struct AccessTokenResponse: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
    }

    // https://docs.github.com/apps/oauth-apps/maintaining-oauth-apps/troubleshooting-oauth-app-access-token-request-errors
    struct AccessTokenErrorResponse: Decodable {
        let error: String
        let errorDescription: String?
        let errorUri: String?
    }

    enum AccessTokenError: Error {
        case invalidResponse
        case reason(AccessTokenErrorResponse)
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
        do {
            return try decoder.decode(AccessTokenResponse.self, from: data)
        } catch let error as DecodingError {
            if case .keyNotFound = error {
                let response = try decoder.decode(AccessTokenErrorResponse.self, from: data)
                throw AccessTokenError.reason(response)
            }
            throw error
        } catch {
            throw error
        }
    }

    func me() async throws -> String {
        let apolloClient = setupApolloClient()
        let result = try await apolloClient.fetch(query: API.MeQuery())
        return result.viewer.login
    }

    func projectOverview(owner: GithubProjectOwner, number: Int) async throws -> GithubProject? {
        let apolloClient = setupApolloClient()
        let projectOverview: ProjectOverview
        let viewOverviews: [ProjectViewOverview]
        if case .organization(let name) = owner {
            let result = try await apolloClient.fetch(query: API.OrganizationProjectOverviewQuery(login: name, number: number))
            if let projectV2 = result.organization?.projectV2, let views = projectV2.views.nodes?.compactMap({ $0?.fragments.projectViewOverview }) {
                projectOverview = projectV2.fragments.projectOverview
                viewOverviews = views
            } else {
                return nil
            }
        } else {
            let result = try await apolloClient.fetch(query: API.ViewerProjectOverviewQuery(number: number))
            if let projectV2 = result.viewer.projectV2, let views = projectV2.views.nodes?.compactMap({ $0?.fragments.projectViewOverview }) {
                projectOverview = projectV2.fragments.projectOverview
                viewOverviews = views
            } else {
                return nil
            }
        }
        let views = viewOverviews.compactMap { view in
            if let verticalField = view.verticalGroupByFields?.nodes?.first??.asProjectV2FieldCommon?.name {
                return GithubProjectView(id: view.id, name: view.name, varticalFieldName: verticalField)
            } else {
                return nil
            }
        }
        let statusFields: [GithubProjectStatusField]
        if let options = projectOverview.field?.asProjectV2SingleSelectField?.options {
            statusFields = options.enumerated().map { (index, option) in
                GithubProjectStatusField(name: option.name, fieldDescription: option.description, color: option.color.rawValue, order: index)
            }
        } else {
            statusFields = []
        }
        return GithubProject(id: projectOverview.id,
                             number: number,
                             owner: owner,
                             title: projectOverview.title,
                             url: projectOverview.url,
                             statusFields: statusFields,
                             views: views,
                             items: [])
    }

    func projectItems(owner: GithubProjectOwner, number: Int) async throws -> [GithubProjectItem] {
        let apolloClient = setupApolloClient()
        if case .organization(let name) = owner {
            let result = try await apolloClient.fetch(query: API.OrganizationProjectItemsQuery(login: name, number: number, after: nil))
            if let project = result.organization?.projectV2, let items = project.items.nodes?.compactMap({ $0 }) {
                return items.map { item in
                    let itemType: GithubItemType
                    let title: String
                    let statusField: GithubProjectItemField?
                    if let draftIssue = item.content?.asDraftIssue {
                        itemType = .draftIssue
                        title = draftIssue.title
                    } else if let issue = item.content?.asIssue {
                        itemType = .issue(number: issue.number, repository: issue.repository.name)
                        title = issue.title
                    } else if let pullRequest = item.content?.asPullRequest {
                        itemType = .pullRequest(number: pullRequest.number, repository: pullRequest.repository.name)
                        title = pullRequest.title
                    } else {
                        fatalError("Unsupported item type")
                    }
                    if let status = item.status?.fragments.columnField.asProjectV2ItemFieldSingleSelectValue {
                        statusField = GithubProjectItemField(name: status.name, fieldDescription: status.description, color: status.color.rawValue)
                    } else {
                        statusField = nil
                    }
                    return GithubProjectItem(id: item.id, title: title, itemType: itemType, statusField: statusField)
                }
            }
        } else {
            let result = try await apolloClient.fetch(query: API.ViewerProjectItemsQuery(number: number, after: nil))
            if let project = result.viewer.projectV2, let items = project.items.nodes?.compactMap({ $0 }) {
                return items.map { item in
                    let itemType: GithubItemType
                    let title: String
                    let statusField: GithubProjectItemField?
                    if let draftIssue = item.content?.asDraftIssue {
                        itemType = .draftIssue
                        title = draftIssue.title
                    } else if let issue = item.content?.asIssue {
                        itemType = .issue(number: issue.number, repository: issue.repository.name)
                        title = issue.title
                    } else if let pullRequest = item.content?.asPullRequest {
                        itemType = .pullRequest(number: pullRequest.number, repository: pullRequest.repository.name)
                        title = pullRequest.title
                    } else {
                        fatalError("Unsupported item type")
                    }
                    if let status = item.status?.fragments.columnField.asProjectV2ItemFieldSingleSelectValue {
                        statusField = GithubProjectItemField(name: status.name, fieldDescription: status.description, color: status.color.rawValue)
                    } else {
                        statusField = nil
                    }
                    return GithubProjectItem(id: item.id, title: title, itemType: itemType, statusField: statusField)
                }
            }
        }
        return []
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
