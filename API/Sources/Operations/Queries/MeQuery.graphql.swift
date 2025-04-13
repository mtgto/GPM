// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MeQuery: GraphQLQuery {
  public static let operationName: String = "Me"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Me { viewer { __typename login } }"#
    ))

  public init() {}

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
        .field("login", String.self),
      ] }

      /// The username used to login.
      public var login: String { __data["login"] }
    }
  }
}
