// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ViewerProjectOverviewQuery: GraphQLQuery {
  public static let operationName: String = "ViewerProjectOverview"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ViewerProjectOverview($number: Int!) { viewer { __typename projectV2(number: $number) { __typename ...ProjectOverview } } }"#,
      fragments: [ProjectOverview.self]
    ))

  public var number: Int

  public init(number: Int) {
    self.number = number
  }

  public var __variables: Variables? { ["number": number] }

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
          .fragment(ProjectOverview.self),
        ] }

        /// The Node ID of the ProjectV2 object
        public var id: API.ID { __data["id"] }
        /// The project's name.
        public var title: String { __data["title"] }
        /// The HTTP URL for this project
        public var url: API.URI { __data["url"] }
        /// List of views in the project
        public var views: Views { __data["views"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var projectOverview: ProjectOverview { _toFragment() }
        }

        public typealias Views = ProjectOverview.Views
      }
    }
  }
}
