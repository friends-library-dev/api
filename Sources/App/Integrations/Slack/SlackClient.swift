import Foundation

extension Slack {
  struct Client {
    var send = send(_:)
    var sendSync = sendSync(_:)
  }

  enum ClientError: Error {
    case failedToSend(String?)
  }
}

private struct SendResponse: Decodable {
  let ok: Bool
  let error: String?
}

private let MAX_SAFE_SLACK_MSG_LENGTH = 2900

private func send(_ slack: Slack.Message) async {
  var slack = slack
  switch slack.channel {
    case .info, .orders, .downloads, .other:
      Current.logger.info("Sent a slack to `\(slack.channel)`: \(slack.text)")
    case .errors:
      Current.logger.error("Sent a slack to `\(slack.channel)`: \(slack.text)")
    case .audioDownloads, .debug:
      Current.logger.debug("Sent a slack to `\(slack.channel)`: \(slack.text)")
  }

  guard Env.mode != .dev || Env.get("SLACK_DEV") != nil else { return }

  if case .text(let text) = slack.content {
    let safeText = text.dropLast(max(0, text.count - MAX_SAFE_SLACK_MSG_LENGTH))
    slack.content = .text(String(safeText))
  }

  do {
    let response = try await HTTP.postJson(
      slack,
      to: "https://slack.com/api/chat.postMessage",
      decoding: SendResponse.self,
      auth: .bearer(slack.channel.token),
      keyEncodingStrategy: .convertToSnakeCase
    )
    if !response.ok {
      Current.logger.error("Failed to send slack, error=\(response.error ?? "")")
    }
  } catch {
    Current.logger.error("Failed to send slack, error=\(error)")
  }
}

private func sendSync(_ slack: Slack.Message) {
  let semaphore = DispatchSemaphore(value: 0)
  Task {
    await send(slack)
    semaphore.signal()
  }
  _ = semaphore.wait(timeout: .distantFuture)
}

// extensions

extension Slack.Channel {
  var string: String {
    switch self {
      case .errors:
        return "#errors"
      case .info:
        return "#info"
      case .orders:
        return "#orders"
      case .downloads:
        return "#downloads"
      case .audioDownloads:
        return "#audio-downloads"
      case .debug:
        return "#debug"
      case .other(let channel):
        return channel
    }
  }

  var token: String {
    if Env.mode == .staging || Env.mode == .dev {
      return Env.SLACK_API_TOKEN_WORKSPACE_BOT
    }
    switch self {
      case .debug, .audioDownloads:
        return Env.SLACK_API_TOKEN_WORKSPACE_BOT
      case .errors, .info, .orders, .downloads, .other:
        return Env.SLACK_API_TOKEN_WORKSPACE_MAIN
    }
  }
}

extension Slack.Emoji: CustomStringConvertible {
  var description: String {
    switch self {
      case .fireEngine:
        return "fire_engine"
      case .robotFace:
        return "robot_face"
      case .books:
        return "books"
      case .orangeBook:
        return "orange_book"
      case .custom(let custom):
        return custom
    }
  }
}

extension Slack.Client {
  static let mock = Slack.Client(send: { _ in }, sendSync: { _ in })
}
