import Fluent
import Foundation
import Graphiti
import Vapor

let appSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  Scalar(Int64.self)
  DateScalar(formatter: ISO8601DateFormatter())

  Enum(EditionType.self)
  Enum(Lang.self)
  Enum(Download.Format.self)
  Enum(Download.AudioQuality.self)
  Enum(Download.DownloadSource.self)
  Enum(Order.PrintJobStatus.self)
  Enum(Order.ShippingLevel.self)
  Enum(Order.OrderSource.self)
  Enum(DocumentTag.TagType.self)
  Enum(Scope.self)
  Enum(Friend.Gender.self)
  Enum(PrintSize.self)
  Enum(PrintSizeVariant.self)
  Enum(AppSchema.SubmitContactFormInput.Subject.self)

  AppSchema.IdentifyEntityType
  AppSchema.GenericResponseType
  AppSchema.ModelsCountsType
  AppSchema.ShippingAddressType
  AppSchema.ShippingAddressInputType
  AppSchema.SubmitContactFormInputType
  AppSchema.LogJsErrorDataInputType
  AppSchema.DownloadableFileType

  // isbn types
  AppSchema.IsbnType
  AppSchema.CreateIsbnInputType
  AppSchema.UpdateIsbnInputType

  AppSchema.ArtifactProductionVersionType
  AppSchema.CreateArtifactProductionVersionInputType

  AppSchema.DownloadType
  AppSchema.CreateDownloadInputType

  // token types
  AppSchema.TokenType
  AppSchema.TokenScopeType
  AppSchema.CreateTokenInputType
  AppSchema.CreateTokenScopeInputType
  AppSchema.UpdateTokenInputType
  AppSchema.UpdateTokenScopeInputType

  // order types
  AppSchema.OrderType
  AppSchema.OrderItemType
  AppSchema.CreateOrderInputType
  AppSchema.CreateOrderItemInputType
  AppSchema.UpdateOrderInputType
  AppSchema.FreeOrderRequestType
  AppSchema.CreateFreeOrderRequestInputType
  AppSchema.OrderInitializationType
  AppSchema.CreateOrderInitializationInputType
  AppSchema.BrickOrderInputType
  AppSchema.PrintJobExploratoryItemInputType
  AppSchema.GetPrintJobExploratoryMetadataInputType
  AppSchema.PrintJobExploratoryMetadataType

  // edition types
  AppSchema.EditionImageType
  AppSchema.EditionSquareImagesType
  AppSchema.EditionThreeDImagesType
  AppSchema.EditionImagesType
  AppSchema.EditionType
  AppSchema.CreateEditionInputType
  AppSchema.UpdateEditionInputType

  // document types
  AppSchema.DocumentType
  AppSchema.CreateDocumentInputType
  AppSchema.CreateDocumentTagInputType
  AppSchema.UpdateDocumentInputType
  AppSchema.UpdateDocumentTagInputType
  AppSchema.DocumentTagType
  AppSchema.RelatedDocumentType
  AppSchema.CreateRelatedDocumentInputType
  AppSchema.UpdateRelatedDocumentInputType

  // friend types
  AppSchema.FriendResidenceType
  AppSchema.FriendType
  AppSchema.CreateFriendInputType
  AppSchema.UpdateFriendInputType
  AppSchema.FriendQuoteType
  AppSchema.CreateFriendQuoteInputType
  AppSchema.UpdateFriendQuoteInputType
  AppSchema.CreateFriendResidenceInputType
  AppSchema.UpdateFriendResidenceInputType
  AppSchema.FriendResidenceDurationType
  AppSchema.CreateFriendResidenceDurationInputType
  AppSchema.UpdateFriendResidenceDurationInputType

  // edition impression types
  AppSchema.EditionImpressionEbookFilesType
  AppSchema.EditionImpressionPaperbackFilesType
  AppSchema.EditionImpressionFilesType
  AppSchema.EditionImpressionType
  AppSchema.CreateEditionImpressionInputType
  AppSchema.UpdateEditionImpressionInputType

  // edition chapter types
  AppSchema.EditionChapterType
  AppSchema.CreateEditionChapterInputType
  AppSchema.UpdateEditionChapterInputType

  // audio types
  AppSchema.AudioFileQualitiesType
  AppSchema.AudioFilesType
  AppSchema.AudioType
  AppSchema.CreateAudioInputType
  AppSchema.UpdateAudioInputType
  AppSchema.AudioPartType
  AppSchema.CreateAudioPartInputType
  AppSchema.UpdateAudioPartInputType

  Query {
    AppSchema.getModelsCounts
    AppSchema.getFriend
    AppSchema.getFriends
    AppSchema.getFriendQuote
    AppSchema.getFriendResidence
    AppSchema.getFriendResidenceDuration
    AppSchema.getDocument
    AppSchema.getDocuments
    AppSchema.getDocumentTag
    AppSchema.getDocumentTags
    AppSchema.getEdition
    AppSchema.getEditions
    AppSchema.getEditionImpression
    AppSchema.getIsbn
    AppSchema.getEditionChapter
    AppSchema.getAudio
    AppSchema.getAudios
    AppSchema.getAudioPart
    AppSchema.getToken
    AppSchema.getTokens

    Field("getLatestArtifactProductionVersion", at: Resolver.getLatestArtifactProductionVersion)

    Field("getTokenByValue", at: Resolver.getTokenByValue) {
      Argument("value", at: \.value)
    }

    // order queries
    AppSchema.getOrder
    AppSchema.getOrders
    AppSchema.getFreeOrderRequest
    AppSchema.getPrintJobExploratoryMetadata
  }

  Mutation {
    AppSchema.submitContactForm
    AppSchema.createDownload
    AppSchema.createArtifactProductionVersion
    AppSchema.logJsError

    // token mutations
    AppSchema.createToken
    AppSchema.updateToken
    AppSchema.deleteToken
    AppSchema.createTokenScope
    AppSchema.updateTokenScope
    AppSchema.deleteTokenScope

    // isbn mutations
    AppSchema.createIsbn
    AppSchema.updateIsbn
    AppSchema.deleteIsbn

    // friend mutations
    AppSchema.createFriend
    AppSchema.updateFriend
    AppSchema.deleteFriend
    AppSchema.createFriendQuote
    AppSchema.updateFriendQuote
    AppSchema.deleteFriendQuote
    AppSchema.createFriendResidence
    AppSchema.updateFriendResidence
    AppSchema.deleteFriendResidence
    AppSchema.createFriendResidenceDuration
    AppSchema.updateFriendResidenceDuration
    AppSchema.deleteFriendResidenceDuration

    // document mutations
    AppSchema.createDocument
    AppSchema.updateDocument
    AppSchema.deleteDocument
    AppSchema.createDocumentTag
    AppSchema.updateDocumentTag
    AppSchema.deleteDocumentTag
    AppSchema.createRelatedDocument
    AppSchema.updateRelatedDocument
    AppSchema.deleteRelatedDocument

    // edition mutations
    AppSchema.createEdition
    AppSchema.updateEdition
    AppSchema.deleteEdition
    AppSchema.deleteEditionEditionChapters

    // edition impression mutations
    AppSchema.createEditionImpression
    AppSchema.updateEditionImpression
    AppSchema.deleteEditionImpression

    // edition chapter mutations
    AppSchema.createEditionChapter
    AppSchema.createEditionChapters
    AppSchema.updateEditionChapter
    AppSchema.deleteEditionChapter

    // audio mutations
    AppSchema.createAudio
    AppSchema.updateAudio
    AppSchema.deleteAudio
    AppSchema.createAudioPart
    AppSchema.updateAudioPart
    AppSchema.deleteAudioPart

    // order mutations
    AppSchema.updateOrder
    AppSchema.updateOrders
    AppSchema.createFreeOrderRequest
    AppSchema.createOrderInitialization
    AppSchema.brickOrder
    AppSchema.sendOrderConfirmationEmail
    Field("createOrderWithItems", at: Resolver.createOrderWithItems) {
      Argument("order", at: \.order)
      Argument("items", at: \.items)
    }
  }

  Types(OrderItem.self, TokenScope.self, RelatedDocument.self)
}
