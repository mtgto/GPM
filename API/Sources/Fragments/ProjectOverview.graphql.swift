// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ProjectOverview: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectOverview on ProjectV2 { __typename id title url views(first: 100) { __typename nodes { __typename id name layout verticalGroupByFields(first: 100) { __typename nodes { __typename ... on ProjectV2FieldCommon { name } } } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2 }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", API.ID.self),
    .field("title", String.self),
    .field("url", API.URI.self),
    .field("views", Views.self, arguments: ["first": 100]),
  ] }

  /// The Node ID of the ProjectV2 object
  public var id: API.ID { __data["id"] }
  /// The project's name.
  public var title: String { __data["title"] }
  /// The HTTP URL for this project
  public var url: API.URI { __data["url"] }
  /// List of views in the project
  public var views: Views { __data["views"] }

  /// Views
  ///
  /// Parent Type: `ProjectV2ViewConnection`
  public struct Views: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2ViewConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("nodes", [Node?]?.self),
    ] }

    /// A list of nodes.
    public var nodes: [Node?]? { __data["nodes"] }

    /// Views.Node
    ///
    /// Parent Type: `ProjectV2View`
    public struct Node: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2View }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("name", String.self),
        .field("layout", GraphQLEnum<API.ProjectV2ViewLayout>.self),
        .field("verticalGroupByFields", VerticalGroupByFields?.self, arguments: ["first": 100]),
      ] }

      /// The Node ID of the ProjectV2View object
      public var id: API.ID { __data["id"] }
      /// The project view's name.
      public var name: String { __data["name"] }
      /// The project view's layout.
      public var layout: GraphQLEnum<API.ProjectV2ViewLayout> { __data["layout"] }
      /// The view's vertical-group-by field.
      public var verticalGroupByFields: VerticalGroupByFields? { __data["verticalGroupByFields"] }

      /// Views.Node.VerticalGroupByFields
      ///
      /// Parent Type: `ProjectV2FieldConfigurationConnection`
      public struct VerticalGroupByFields: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2FieldConfigurationConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Views.Node.VerticalGroupByFields.Node
        ///
        /// Parent Type: `ProjectV2FieldConfiguration`
        public struct Node: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Unions.ProjectV2FieldConfiguration }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsProjectV2FieldCommon.self),
          ] }

          public var asProjectV2FieldCommon: AsProjectV2FieldCommon? { _asInlineFragment() }

          /// Views.Node.VerticalGroupByFields.Node.AsProjectV2FieldCommon
          ///
          /// Parent Type: `ProjectV2FieldCommon`
          public struct AsProjectV2FieldCommon: API.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = ProjectOverview.Views.Node.VerticalGroupByFields.Node
            public static var __parentType: any ApolloAPI.ParentType { API.Interfaces.ProjectV2FieldCommon }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("name", String.self),
            ] }

            /// The project field's name.
            public var name: String { __data["name"] }
          }
        }
      }
    }
  }
}
