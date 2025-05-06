// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ProjectItemOverview: API.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectItemOverview on ProjectV2Item { __typename id content { __typename ... on DraftIssue { title } ... on Issue { title issueState: state number repository { __typename name } } ... on PullRequest { title pullRequestState: state number repository { __typename name } } } status: fieldValueByName(name: "Status") { __typename ...ColumnField } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2Item }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", API.ID.self),
    .field("content", Content?.self),
    .field("fieldValueByName", alias: "status", Status?.self, arguments: ["name": "Status"]),
  ] }

  /// The Node ID of the ProjectV2Item object
  public var id: API.ID { __data["id"] }
  /// The content of the referenced draft issue, issue, or pull request
  public var content: Content? { __data["content"] }
  /// The field value of the first project field which matches the 'name' argument that is set on the item.
  public var status: Status? { __data["status"] }

  /// Content
  ///
  /// Parent Type: `ProjectV2ItemContent`
  public struct Content: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Unions.ProjectV2ItemContent }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .inlineFragment(AsDraftIssue.self),
      .inlineFragment(AsIssue.self),
      .inlineFragment(AsPullRequest.self),
    ] }

    public var asDraftIssue: AsDraftIssue? { _asInlineFragment() }
    public var asIssue: AsIssue? { _asInlineFragment() }
    public var asPullRequest: AsPullRequest? { _asInlineFragment() }

    /// Content.AsDraftIssue
    ///
    /// Parent Type: `DraftIssue`
    public struct AsDraftIssue: API.InlineFragment {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public typealias RootEntityType = ProjectItemOverview.Content
      public static var __parentType: any ApolloAPI.ParentType { API.Objects.DraftIssue }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("title", String.self),
      ] }

      /// The title of the draft issue
      public var title: String { __data["title"] }
    }

    /// Content.AsIssue
    ///
    /// Parent Type: `Issue`
    public struct AsIssue: API.InlineFragment {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public typealias RootEntityType = ProjectItemOverview.Content
      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Issue }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("title", String.self),
        .field("state", alias: "issueState", GraphQLEnum<API.IssueState>.self),
        .field("number", Int.self),
        .field("repository", Repository.self),
      ] }

      /// Identifies the issue title.
      public var title: String { __data["title"] }
      /// Identifies the state of the issue.
      public var issueState: GraphQLEnum<API.IssueState> { __data["issueState"] }
      /// Identifies the issue number.
      public var number: Int { __data["number"] }
      /// The repository associated with this node.
      public var repository: Repository { __data["repository"] }

      /// Content.AsIssue.Repository
      ///
      /// Parent Type: `Repository`
      public struct Repository: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.Repository }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
        ] }

        /// The name of the repository.
        public var name: String { __data["name"] }
      }
    }

    /// Content.AsPullRequest
    ///
    /// Parent Type: `PullRequest`
    public struct AsPullRequest: API.InlineFragment {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public typealias RootEntityType = ProjectItemOverview.Content
      public static var __parentType: any ApolloAPI.ParentType { API.Objects.PullRequest }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("title", String.self),
        .field("state", alias: "pullRequestState", GraphQLEnum<API.PullRequestState>.self),
        .field("number", Int.self),
        .field("repository", Repository.self),
      ] }

      /// Identifies the pull request title.
      public var title: String { __data["title"] }
      /// Identifies the state of the pull request.
      public var pullRequestState: GraphQLEnum<API.PullRequestState> { __data["pullRequestState"] }
      /// Identifies the pull request number.
      public var number: Int { __data["number"] }
      /// The repository associated with this node.
      public var repository: Repository { __data["repository"] }

      /// Content.AsPullRequest.Repository
      ///
      /// Parent Type: `Repository`
      public struct Repository: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.Repository }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
        ] }

        /// The name of the repository.
        public var name: String { __data["name"] }
      }
    }
  }

  /// Status
  ///
  /// Parent Type: `ProjectV2ItemFieldValue`
  public struct Status: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Unions.ProjectV2ItemFieldValue }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(ColumnField.self),
    ] }

    public var asProjectV2ItemFieldSingleSelectValue: AsProjectV2ItemFieldSingleSelectValue? { _asInlineFragment() }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var columnField: ColumnField { _toFragment() }
    }

    /// Status.AsProjectV2ItemFieldSingleSelectValue
    ///
    /// Parent Type: `ProjectV2ItemFieldSingleSelectValue`
    public struct AsProjectV2ItemFieldSingleSelectValue: API.InlineFragment, ApolloAPI.CompositeInlineFragment {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public typealias RootEntityType = ProjectItemOverview.Status
      public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2ItemFieldSingleSelectValue }
      public static var __mergedSources: [any ApolloAPI.SelectionSet.Type] { [
        ProjectItemOverview.Status.self,
        ColumnField.AsProjectV2ItemFieldSingleSelectValue.self
      ] }

      /// The Node ID of the ProjectV2ItemFieldSingleSelectValue object
      public var id: API.ID { __data["id"] }
      /// The color applied to the selected single-select option.
      public var color: GraphQLEnum<API.ProjectV2SingleSelectFieldOptionColor> { __data["color"] }
      /// The name of the selected single select option.
      public var name: String? { __data["name"] }
      /// A plain-text description of the selected single-select option, such as what the option means.
      public var description: String? { __data["description"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var columnField: ColumnField { _toFragment() }
      }
    }
  }
}
