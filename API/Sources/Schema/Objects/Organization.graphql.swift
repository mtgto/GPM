// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// An account on GitHub, with one or more owners, that has repositories, members and teams.
  static let Organization = ApolloAPI.Object(
    typename: "Organization",
    implementedInterfaces: [
      Interfaces.Actor.self,
      Interfaces.AnnouncementBannerI.self,
      Interfaces.MemberStatusable.self,
      Interfaces.Node.self,
      Interfaces.PackageOwner.self,
      Interfaces.ProfileOwner.self,
      Interfaces.ProjectOwner.self,
      Interfaces.ProjectV2Owner.self,
      Interfaces.ProjectV2Recent.self,
      Interfaces.RepositoryDiscussionAuthor.self,
      Interfaces.RepositoryDiscussionCommentAuthor.self,
      Interfaces.RepositoryOwner.self,
      Interfaces.Sponsorable.self,
      Interfaces.UniformResourceLocatable.self
    ],
    keyFields: nil
  )
}