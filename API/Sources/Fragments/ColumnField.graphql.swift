// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ColumnField: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ColumnField on ProjectV2ItemFieldValue { __typename ... on ProjectV2ItemFieldSingleSelectValue { id color name description } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { API.Unions.ProjectV2ItemFieldValue }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .inlineFragment(AsProjectV2ItemFieldSingleSelectValue.self),
  ] }

  public var asProjectV2ItemFieldSingleSelectValue: AsProjectV2ItemFieldSingleSelectValue? { _asInlineFragment() }

  /// AsProjectV2ItemFieldSingleSelectValue
  ///
  /// Parent Type: `ProjectV2ItemFieldSingleSelectValue`
  public struct AsProjectV2ItemFieldSingleSelectValue: API.InlineFragment {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public typealias RootEntityType = ColumnField
    public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2ItemFieldSingleSelectValue }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("id", API.ID.self),
      .field("color", GraphQLEnum<API.ProjectV2SingleSelectFieldOptionColor>.self),
      .field("name", String?.self),
      .field("description", String?.self),
    ] }

    /// The Node ID of the ProjectV2ItemFieldSingleSelectValue object
    public var id: API.ID { __data["id"] }
    /// The color applied to the selected single-select option.
    public var color: GraphQLEnum<API.ProjectV2SingleSelectFieldOptionColor> { __data["color"] }
    /// The name of the selected single select option.
    public var name: String? { __data["name"] }
    /// A plain-text description of the selected single-select option, such as what the option means.
    public var description: String? { __data["description"] }
  }
}
