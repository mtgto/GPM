// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// The possible states of a pull request.
public enum PullRequestState: String, EnumType {
  /// A pull request that has been closed without being merged.
  case closed = "CLOSED"
  /// A pull request that has been closed by being merged.
  case merged = "MERGED"
  /// A pull request that is still open.
  case open = "OPEN"
}
