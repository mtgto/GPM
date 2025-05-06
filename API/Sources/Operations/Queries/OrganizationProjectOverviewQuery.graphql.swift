// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class OrganizationProjectOverviewQuery: GraphQLQuery {
  public static let operationName: String = "OrganizationProjectOverview"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query OrganizationProjectOverview($login: String!, $number: Int!) { organization(login: $login) { __typename projectV2(number: $number) { __typename ...ProjectOverview views(first: 100) { __typename nodes { __typename ...ProjectViewOverview } } } } }"#,
      fragments: [ProjectOverview.self, ProjectViewOverview.self]
    ))

  public var login: String
  public var number: Int

  public init(
    login: String,
    number: Int
  ) {
    self.login = login
    self.number = number
  }

  public var __variables: Variables? { [
    "login": login,
    "number": number
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("organization", Organization?.self, arguments: ["login": .variable("login")]),
    ] }

    /// Lookup a organization by login.
    public var organization: Organization? { __data["organization"] }

    /// Organization
    ///
    /// Parent Type: `Organization`
    public struct Organization: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Organization }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("projectV2", ProjectV2?.self, arguments: ["number": .variable("number")]),
      ] }

      /// Find a project by number.
      public var projectV2: ProjectV2? { __data["projectV2"] }

      /// Organization.ProjectV2
      ///
      /// Parent Type: `ProjectV2`
      public struct ProjectV2: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2 }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("views", Views.self, arguments: ["first": 100]),
          .fragment(ProjectOverview.self),
        ] }

        /// List of views in the project
        public var views: Views { __data["views"] }
        /// The Node ID of the ProjectV2 object
        public var id: API.ID { __data["id"] }
        /// The project's name.
        public var title: String { __data["title"] }
        /// The HTTP URL for this project
        public var url: API.URI { __data["url"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var projectOverview: ProjectOverview { _toFragment() }
        }

        /// Organization.ProjectV2.Views
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

          /// Organization.ProjectV2.Views.Node
          ///
          /// Parent Type: `ProjectV2View`
          public struct Node: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProjectV2View }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(ProjectViewOverview.self),
            ] }

            /// The Node ID of the ProjectV2View object
            public var id: API.ID { __data["id"] }
            /// The project view's name.
            public var name: String { __data["name"] }
            /// The project view's layout.
            public var layout: GraphQLEnum<API.ProjectV2ViewLayout> { __data["layout"] }
            /// The view's vertical-group-by field.
            public var verticalGroupByFields: VerticalGroupByFields? { __data["verticalGroupByFields"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var projectViewOverview: ProjectViewOverview { _toFragment() }
            }

            public typealias VerticalGroupByFields = ProjectViewOverview.VerticalGroupByFields
          }
        }
      }
    }
  }
}
