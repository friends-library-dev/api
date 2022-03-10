import Foundation

enum Slack {}

extension Slack {
  enum Emoji {
    case fireEngine
    case robotFace
    case books
    case orangeBook
    case custom(String)
  }

  enum Channel {
    case errors
    case info
    case orders
    case downloads
    case audioDownloads
    case debug
    case other(String)
  }

  struct Message {
    enum Content {
      indirect enum Block {
        case header(text: String)
        case image(url: URL, altText: String)
        case section(text: String, accessory: Block?)
        case divider
      }

      case text(String)
      case blocks([Block], String)
    }

    var content: Content
    var channel: Channel
    var emoji: Emoji
    var username: String

    var text: String {
      switch content {
        case .text(let text):
          return text
        case .blocks(_, let fallbackText):
          return fallbackText
      }
    }

    init(
      text: String,
      channel: Channel,
      emoji: Emoji = .robotFace,
      username: String = "FLP Bot"
    ) {
      content = .text(text)
      self.channel = channel
      self.emoji = emoji
      self.username = username
    }

    init(
      blocks: [Content.Block],
      fallbackText: String,
      channel: Channel,
      emoji: Emoji = .robotFace,
      username: String = "FLP Bot"
    ) {
      content = .blocks(blocks, fallbackText)
      self.channel = channel
      self.emoji = emoji
      self.username = username
    }
  }
}

// extensions

extension Slack.Message {
  static func link(to url: String, withText text: String) -> String {
    "<\(url)|\(text)>"
  }

  static func error(_ text: String, emoji: Slack.Emoji = .fireEngine) -> Slack.Message {
    .init(text: text, channel: .errors, emoji: emoji)
  }

  static func info(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .info, emoji: emoji)
  }

  static func order(_ text: String, emoji: Slack.Emoji = .books) -> Slack.Message {
    .init(text: text, channel: .orders, emoji: emoji)
  }

  static func download(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .downloads, emoji: emoji)
  }

  static func audio(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .audioDownloads, emoji: emoji)
  }

  static func debug(_ text: String, emoji: Slack.Emoji = .robotFace) -> Slack.Message {
    .init(text: text, channel: .debug, emoji: emoji)
  }
}

func slackError(_ msg: String) async {
  await Current.slackClient.send(.error(msg))
}

func slackDebug(_ msg: String) async {
  await Current.slackClient.send(.debug(msg))
}

func slackAudio(_ msg: String) async {
  await Current.slackClient.send(.audio(msg))
}

func slackDownload(_ msg: String) async {
  await Current.slackClient.send(.download(msg))
}

func slackInfo(_ msg: String) async {
  await Current.slackClient.send(.info(msg))
}

func slackOrder(_ msg: String) async {
  await Current.slackClient.send(.order(msg))
}

extension Slack.Emoji: Equatable {}
extension Slack.Channel: Equatable {}
extension Slack.Message: Equatable {}
extension Slack.Message.Content: Equatable {}
extension Slack.Message.Content.Block: Equatable {}
