// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ViewerProjectItemsQuery: GraphQLQuery {
  public static let operationName: String = "ViewerProjectItems"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ViewerProjectItems($number: Int!, $columnField: String!, $after: String) { viewer { __typename projectV2(number: $number) { __typename items(after: $after) { __typename nodes { __typename ...ProjectItemOverview } pageInfo { __typename hasNextPage endCursor } } } } }"#,
      fragments: [ColumnField.self, ProjectItemOverview.self]
    ))

  public var number: Int
  public var columnField: String
  public var after: GraphQLNullable<String>

  public init(
    number: Int,
    columnField: String,
    after: GraphQLNullable<String>
  ) {
    self.number = number
    self.columnField = columnField
    self.after = after
  }

  public var __variables: Variables? { [
    "number": number,
    "columnField": columnField,
    "after": after
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("viewer", Viewer.self),
    ] }

    /// The currently authenticated user.
    public var viewer: Viewer { __data["viewer"] }

    /// Viewer
    ///
    /// Parent Type: `User`
    public struct Viewer: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("projectV2", ProjectV2?.self, arguments: ["number": .variable("number")]),
      ] }

      /// Find a project by number.
      public var projectV2: ProjectV2? { __data["projectV2"] }

      /// Viewer.ProjectV2
      ///
      /// Parent Type: `ProjectV2`
      public struct ProjectV2: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2 }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("items", Items.self, arguments: ["after": .variable("after")]),
        ] }

        /// List of items in the project
        public var items: Items { __data["items"] }

        /// Viewer.ProjectV2.Items
        ///
        /// Parent Type: `ProjectV2ItemConnection`
        public struct Items: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2ItemConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
            .field("pageInfo", PageInfo.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }
          /// Information to aid in pagination.
          public var pageInfo: PageInfo { __data["pageInfo"] }

          /// Viewer.ProjectV2.Items.Node
          ///
          /// Parent Type: `ProjectV2Item`
          public struct Node: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2Item }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(ProjectItemOverview.self),
            ] }

            /// The Node ID of the ProjectV2Item object
            public var id: API.ID { __data["id"] }
            /// The content of the referenced draft issue, issue, or pull request
            public var content: Content? { __data["content"] }
            /// The field value of the first project field which matches the 'name' argument that is set on the item.
            public var fieldValueByName: FieldValueByName? { __data["fieldValueByName"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var projectItemOverview: ProjectItemOverview { _toFragment() }
            }

            public typealias Content = ProjectItemOverview.Content

            public typealias FieldValueByName = ProjectItemOverview.FieldValueByName
          }

          /// Viewer.ProjectV2.Items.PageInfo
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
}
