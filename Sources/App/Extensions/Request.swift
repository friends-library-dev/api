import Vapor

extension Request {
  var ipAddress: String? {
    headers.first(name: .xForwardedFor)
      ?? headers.first(name: "X-Real-IP")
      ?? remoteAddress?.ipAddress
  }
}
