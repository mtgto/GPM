// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ProjectViewOverview: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectViewOverview on ProjectV2View { __typename id name layout verticalGroupByFields(first: 100) { __typename nodes { __typename ... on ProjectV2FieldCommon { name } } } }"#
  }

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

  /// VerticalGroupByFields
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

    /// VerticalGroupByFields.Node
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

      /// VerticalGroupByFields.Node.AsProjectV2FieldCommon
      ///
      /// Parent Type: `ProjectV2FieldCommon`
      public struct AsProjectV2FieldCommon: API.InlineFragment {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public typealias RootEntityType = ProjectViewOverview.VerticalGroupByFields.Node
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
