// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ProjectOverview: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectOverview on ProjectV2 { __typename id title url field(name: "Status") { __typename ... on ProjectV2SingleSelectField { options { __typename name description color } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2 }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", API.ID.self),
    .field("title", String.self),
    .field("url", API.URI.self),
    .field("field", Field?.self, arguments: ["name": "Status"]),
  ] }

  /// The Node ID of the ProjectV2 object
  public var id: API.ID { __data["id"] }
  /// The project's name.
  public var title: String { __data["title"] }
  /// The HTTP URL for this project
  public var url: API.URI { __data["url"] }
  /// A field of the project
  public var field: Field? { __data["field"] }

  /// Field
  ///
  /// Parent Type: `ProjectV2FieldConfiguration`
  public struct Field: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Unions.ProjectV2FieldConfiguration }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .inlineFragment(AsProjectV2SingleSelectField.self),
    ] }

    public var asProjectV2SingleSelectField: AsProjectV2SingleSelectField? { _asInlineFragment() }

    /// Field.AsProjectV2SingleSelectField
    ///
    /// Parent Type: `ProjectV2SingleSelectField`
    public struct AsProjectV2SingleSelectField: API.InlineFragment {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public typealias RootEntityType = ProjectOverview.Field
      public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2SingleSelectField }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("options", [Option].self),
      ] }

      /// Options for the single select field
      public var options: [Option] { __data["options"] }

      /// Field.AsProjectV2SingleSelectField.Option
      ///
      /// Parent Type: `ProjectV2SingleSelectFieldOption`
      public struct Option: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2SingleSelectFieldOption }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("description", String.self),
          .field("color", GraphQLEnum<API.ProjectV2SingleSelectFieldOptionColor>.self),
        ] }

        /// The option's name.
        public var name: String { __data["name"] }
        /// The option's plain-text description.
        public var description: String { __data["description"] }
        /// The option's display color.
        public var color: GraphQLEnum<API.ProjectV2SingleSelectFieldOptionColor> { __data["color"] }
      }
    }
  }
}
