// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ProjectsQuery: GraphQLQuery {
  public static let operationName: String = "Projects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Projects($after: String) { repository(owner: "mtgto", name: "GPM") { __typename projectsV2(after: $after) { __typename nodes { __typename id title } pageInfo { __typename hasNextPage endCursor } } } }"#
    ))

  public var after: GraphQLNullable<String>

  public init(after: GraphQLNullable<String>) {
    self.after = after
  }

  public var __variables: Variables? { ["after": after] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("repository", Repository?.self, arguments: [
        "owner": "mtgto",
        "name": "GPM"
      ]),
    ] }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? { __data["repository"] }

    /// Repository
    ///
    /// Parent Type: `Repository`
    public struct Repository: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Repository }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("projectsV2", ProjectsV2.self, arguments: ["after": .variable("after")]),
      ] }

      /// List of projects linked to this repository.
      public var projectsV2: ProjectsV2 { __data["projectsV2"] }

      /// Repository.ProjectsV2
      ///
      /// Parent Type: `ProjectV2Connection`
      public struct ProjectsV2: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2Connection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }

        /// Repository.ProjectsV2.Node
        ///
        /// Parent Type: `ProjectV2`
        public struct Node: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2 }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("title", String.self),
          ] }

          /// The Node ID of the ProjectV2 object
          public var id: API.ID { __data["id"] }
          /// The project's name.
          public var title: String { __data["title"] }
        }

        /// Repository.ProjectsV2.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool.self),
            .field("endCursor", String?.self),
          ] }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool { __data["hasNextPage"] }
          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? { __data["endCursor"] }
        }
      }
    }
  }
}
