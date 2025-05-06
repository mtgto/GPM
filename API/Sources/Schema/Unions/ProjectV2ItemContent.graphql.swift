// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Unions {
  /// Types that can be inside Project Items.
  static let ProjectV2ItemContent = Union(
    name: "ProjectV2ItemContent",
    possibleTypes: [
      Objects.DraftIssue.self,
      Objects.Issue.self,
      Objects.PullRequest.self
    ]
  )
}