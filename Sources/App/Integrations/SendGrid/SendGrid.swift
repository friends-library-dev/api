import Foundation
import NonEmpty

enum SendGrid {
  struct EmailAddress: Encodable, ExpressibleByStringLiteral {
    let email: String
    let name: String?

    init(email: String, name: String? = nil) {
      self.email = email
      self.name = name
    }

    init(stringLiteral email: String) {
      self.email = email
      name = nil
    }
  }

  struct Email: Encodable {
    struct Personalization: Encodable {
      let to: NonEmpty<[EmailAddress]>
    }

    struct Attachment: Encodable {
      let content: Base64EncodedString
      let filename: String
      var type = "text/plain"

      init(content: Base64EncodedString, filename: String) {
        self.content = content
        self.filename = filename
      }

      init(data: Data, filename: String) throws {
        content = try Base64EncodedString(data: data)
        self.filename = filename
      }
    }

    struct Content: Encodable {
      var type: String
      var value: String
    }

    let personalizations: NonEmpty<[Personalization]>
    let from: EmailAddress
    let replyTo: EmailAddress?
    let subject: String
    let content: NonEmpty<[Content]>
    var attachments: [Attachment]?

    var firstRecipient: EmailAddress {
      personalizations.first.to.first
    }

    var text: String {
      content.first.value
    }

    init(
      to: EmailAddress,
      from: EmailAddress,
      replyTo: EmailAddress? = nil,
      subject: String,
      text: String
    ) {
      personalizations = .init(Personalization(to: .init(to)))
      self.from = from
      self.subject = subject
      self.replyTo = replyTo
      content = .init(Content(type: "text/plain", value: text))
    }

    init(
      to: EmailAddress,
      from: EmailAddress,
      replyTo: EmailAddress? = nil,
      subject: String,
      html: String
    ) {
      personalizations = .init(Personalization(to: .init(to)))
      self.from = from
      self.subject = subject
      self.replyTo = replyTo
      content = .init(Content(type: "text/html", value: html))
    }
  }
}

extension SendGrid.EmailAddress {
  static let friendsLibrary: Self = .init(
    email: "notifications@graphql-api.friendslibrary.com",
    name: "Friends Library"
  )
}

extension SendGrid.EmailAddress: Equatable {}
