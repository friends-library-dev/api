import Fluent
import FluentSQL
import Tagged
import Vapor

struct DatabaseClient {
  // tokens
  var createToken: (Token) async throws -> Void
  var getTokenByValue: (Token.Value) async throws -> Token
  var createTokenScope: (TokenScope) async throws -> Void
  var getTokenScopes: (Token.Id) async throws -> [TokenScope]

  // orders
  var deleteAllOrders: () async throws -> Void
  var createOrderWithItems: (Order) async throws -> Void
  var getOrder: (Order.Id) async throws -> Order
  var getOrdersByPrintJobStatus: (Order.PrintJobStatus) async throws -> [Order]
  var updateOrder: (Order) async throws -> Order
  var updateOrders: ([Order]) async throws -> [Order]

  // free order requests
  var createFreeOrderRequest: (FreeOrderRequest) async throws -> Void
  var getFreeOrderRequest: (FreeOrderRequest.Id) async throws -> FreeOrderRequest

  // downloads
  var createDownload: (Download) async throws -> Void
  var getDownload: (Download.Id) async throws -> Download

  // friends
  var createFriend: (Friend) async throws -> Void
  var createFriends: ([Friend]) async throws -> Void
  var getFriend: (Friend.Id) async throws -> Friend
  var getFriends: () async throws -> [Friend]
  var updateFriend: (Friend) async throws -> Friend
  var updateFriends: ([Friend]) async throws -> [Friend]
  var deleteFriend: (Friend.Id) async throws -> Void
  var deleteAllFriends: () async throws -> Void

  // documents
  var createDocument: (Document) async throws -> Void
  var createDocuments: ([Document]) async throws -> Void
  var getDocument: (Document.Id) async throws -> Document
  var getDocuments: () async throws -> [Document]
  var updateDocument: (Document) async throws -> Document
  var updateDocuments: ([Document]) async throws -> [Document]
  var deleteDocument: (Document.Id) async throws -> Void
  var deleteAllDocuments: () async throws -> Void

  // editions
  var createEdition: (Edition) async throws -> Void
  var createEditions: ([Edition]) async throws -> Void
  var getEdition: (Edition.Id) async throws -> Edition
  var getEditions: () async throws -> [Edition]
  var updateEdition: (Edition) async throws -> Edition
  var updateEditions: ([Edition]) async throws -> [Edition]
  var deleteEdition: (Edition.Id) async throws -> Void
  var deleteAllEditions: () async throws -> Void

  // isbns
  var createIsbn: (Isbn) async throws -> Void
  var createIsbns: ([Isbn]) async throws -> Void
  var getIsbn: (Isbn.Id) async throws -> Isbn
  var getIsbns: () async throws -> [Isbn]
  var updateIsbn: (Isbn) async throws -> Isbn
  var updateIsbns: ([Isbn]) async throws -> [Isbn]
  var deleteIsbn: (Isbn.Id) async throws -> Void
  var deleteAllIsbns: () async throws -> Void

  // document tags
  var createDocumentTagModels: ([DocumentTagModel]) async throws -> Void

  // artifact production versions
  var createArtifactProductionVersion: (ArtifactProductionVersion) async throws -> Void
  var getLatestArtifactProductionVersion: () async throws -> ArtifactProductionVersion
}
