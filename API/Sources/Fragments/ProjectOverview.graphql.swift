// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ProjectOverview: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectOverview on ProjectV2 { __typename id title url }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2 }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", API.ID.self),
    .field("title", String.self),
    .field("url", API.URI.self),
  ] }

  /// The Node ID of the ProjectV2 object
  public var id: API.ID { __data["id"] }
  /// The project's name.
  public var title: String { __data["title"] }
  /// The HTTP URL for this project
  public var url: API.URI { __data["url"] }
}
