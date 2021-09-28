import Fluent
import Foundation
import Graphiti
import Vapor

let AppSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  DateScalar(formatter: ISO8601DateFormatter())

  Enum(EditionType.self)
  Enum(Lang.self)

  Enum(Download.Format.self)
  Enum(Download.AudioQuality.self)
  Enum(Download.DownloadSource.self)
  Enum(Order.PrintJobStatus.self)
  Enum(Order.ShippingLevel.self)
  Enum(Order.OrderSource.self)
  Enum(Scope.self)

  Input(CreateDownloadInput.self) {
    InputField("documentId", at: \.documentId)
    InputField("editionType", at: \.editionType)
    InputField("format", at: \.format)
    InputField("source", at: \.source)
    InputField("isMobile", at: \.isMobile)
    InputField("audioQuality", at: \.audioQuality)
    InputField("audioPartNumber", at: \.audioPartNumber)
    InputField("userAgent", at: \.userAgent)
    InputField("os", at: \.os)
    InputField("browser", at: \.browser)
    InputField("platform", at: \.platform)
    InputField("referrer", at: \.referrer)
    InputField("ip", at: \.ip)
    InputField("city", at: \.city)
    InputField("region", at: \.region)
    InputField("postalCode", at: \.postalCode)
    InputField("country", at: \.country)
    InputField("latitude", at: \.latitude)
    InputField("longitude", at: \.longitude)
  }

  Type(TokenScope.self) {
    Field("id", at: \.id)
    Field("scope", at: \.scope)
    Field("createdAt", at: \.createdAt)
    Field("token", with: \.$token)
  }

  Type(Token.self) {
    Field("id", at: \.id)
    Field("value", at: \.value)
    Field("description", at: \.description)
    Field("createdAt", at: \.createdAt)
    Field("scopes", with: \.$scopes)
  }

  Type(ModelsCounts.self) {
    Field("downloads", at: \.downloads)
    Field("orders", at: \.orders)
    Field("orderItems", at: \.orderItems)
  }

  Type(FreeOrderRequest.self) {
    Field("id", at: \.id)
    Field("email", at: \.email)
    Field("requestedBooks", at: \.requestedBooks)
    Field("aboutRequester", at: \.aboutRequester)
    Field("name", at: \.name)
    Field("addressStreet", at: \.addressStreet)
    Field("addressStreet2", at: \.addressStreet2)
    Field("addressCity", at: \.addressCity)
    Field("addressState", at: \.addressState)
    Field("addressZip", at: \.addressZip)
    Field("addressCountry", at: \.addressCountry)
    Field("source", at: \.source)
    Field("createdAt", at: \.createdAt)
    Field("updatedAt", at: \.updatedAt)
  }

  Type(Order.self) {
    Field("id", at: \.id)
    Field("paymentId", at: \.paymentId)
    Field("printJobStatus", at: \.printJobStatus)
    Field("printJobId", at: \.printJobId)
    Field("amount", at: \.amount)
    Field("shipping", at: \.shipping)
    Field("taxes", at: \.taxes)
    Field("ccFeeOffset", at: \.ccFeeOffset)
    Field("shippingLevel", at: \.shippingLevel)
    Field("email", at: \.email)
    Field("addressName", at: \.addressName)
    Field("addressStreet", at: \.addressStreet)
    Field("addressStreet2", at: \.addressStreet2)
    Field("addressCity", at: \.addressCity)
    Field("addressState", at: \.addressState)
    Field("addressZip", at: \.addressZip)
    Field("addressCountry", at: \.addressCountry)
    Field("lang", at: \.lang)
    Field("source", at: \.source)
    Field("createdAt", at: \.createdAt)
    Field("updatedAt", at: \.updatedAt)
    Field("items", with: \.$items)
    Field("freeOrderRequest", with: \.$freeOrderRequest)
  }

  Type(OrderItem.self) {
    Field("title", at: \.title)
    Field("documentId", at: \.documentId)
    Field("editionType", at: \.editionType)
    Field("quantity", at: \.quantity)
    Field("unitPrice", at: \.unitPrice)
    Field("order", with: \.$order)
  }

  Type(ArtifactProductionVersion.self) {
    Field("id", at: \.id)
    Field("version", at: \.version)
    Field("createdAt", at: \.createdAt)
  }

  Input(UpdateOrderInput.self) {
    InputField("id", at: \.id)
    InputField("printJobStatus", at: \.printJobStatus)
    InputField("printJobId", at: \.printJobId)
  }

  Input(CreateOrderInput.Item.self) {
    InputField("title", at: \.title)
    InputField("documentId", at: \.documentId)
    InputField("editionType", at: \.editionType)
    InputField("quantity", at: \.quantity)
    InputField("unitPrice", at: \.unitPrice)
  }

  Input(CreateFreeOrderRequestInput.self) {
    InputField("email", at: \.email)
    InputField("name", at: \.name)
    InputField("requestedBooks", at: \.requestedBooks)
    InputField("aboutRequester", at: \.aboutRequester)
    InputField("addressStreet", at: \.addressStreet)
    InputField("addressStreet2", at: \.addressStreet2)
    InputField("addressCity", at: \.addressCity)
    InputField("addressState", at: \.addressState)
    InputField("addressZip", at: \.addressZip)
    InputField("addressCountry", at: \.addressCountry)
    InputField("source", at: \.source)
  }

  Input(CreateOrderInput.self) {
    InputField("id", at: \.id)
    InputField("freeOrderRequestId", at: \.freeOrderRequestId)
    InputField("paymentId", at: \.paymentId)
    InputField("printJobStatus", at: \.printJobStatus)
    InputField("printJobId", at: \.printJobId)
    InputField("amount", at: \.amount)
    InputField("shipping", at: \.shipping)
    InputField("taxes", at: \.taxes)
    InputField("ccFeeOffset", at: \.ccFeeOffset)
    InputField("shippingLevel", at: \.shippingLevel)
    InputField("email", at: \.email)
    InputField("addressName", at: \.addressName)
    InputField("addressStreet", at: \.addressStreet)
    InputField("addressStreet2", at: \.addressStreet2)
    InputField("addressCity", at: \.addressCity)
    InputField("addressState", at: \.addressState)
    InputField("addressZip", at: \.addressZip)
    InputField("addressCountry", at: \.addressCountry)
    InputField("lang", at: \.lang)
    InputField("source", at: \.source)
    InputField("items", at: \.items)
  }

  Type(Download.self) {
    Field("id", at: \.id)
    Field("documentId", at: \.documentId)
    Field("editionType", at: \.editionType)
    Field("format", at: \.format)
    Field("source", at: \.source)
    Field("isMobile", at: \.isMobile)
    Field("audioQuality", at: \.audioQuality)
    Field("audioPartNumber", at: \.audioPartNumber)
    Field("userAgent", at: \.userAgent)
    Field("os", at: \.os)
    Field("browser", at: \.browser)
    Field("platform", at: \.platform)
    Field("referrer", at: \.referrer)
    Field("ip", at: \.ip)
    Field("city", at: \.city)
    Field("region", at: \.region)
    Field("postalCode", at: \.postalCode)
    Field("country", at: \.country)
    Field("latitude", at: \.latitude)
    Field("longitude", at: \.longitude)
  }

  Query {
    Field("getOrder", at: Resolver.getOrder) {
      Argument("id", at: \.id)
    }

    Field("getOrders", at: Resolver.getOrders) {
      Argument("printJobStatus", at: \.printJobStatus)
    }

    Field("getTokenByValue", at: Resolver.getTokenByValue) {
      Argument("value", at: \.value)
    }

    Field("getModelsCounts", at: Resolver.getModelsCounts)

    Field("getFreeOrderRequest", at: Resolver.getFreeOrderRequest) {
      Argument("id", at: \.id)
    }

    Field("getLatestArtifactProductionVersion", at: Resolver.getLatestArtifactProductionVersion)
  }

  Mutation {
    Field("createDownload", at: Resolver.createDownload) {
      Argument("input", at: \.input)
    }

    Field("createOrder", at: Resolver.createOrder) {
      Argument("input", at: \.input)
    }

    Field("updateOrder", at: Resolver.updateOrder) {
      Argument("input", at: \.input)
    }

    Field("updateOrders", at: Resolver.updateOrders) {
      Argument("input", at: \.input)
    }

    Field("createFreeOrderRequest", at: Resolver.createFreeOrderRequest) {
      Argument("input", at: \.input)
    }

    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersion) {
      Argument("revision", at: \.revision)
    }
  }

  Types(OrderItem.self, TokenScope.self)
}
