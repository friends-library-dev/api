import Vapor

extension Request {
  var ipAddress: String? {
    let ip = headers.first(name: .xForwardedFor)
      ?? headers.first(name: "X-Real-IP")
      ?? remoteAddress?.ipAddress
    // sometimes we get multiple ip addresses, like `1.2.3.4, 1.2.3.5`
    return ip?.split(separator: ",").first.map { String($0) }
  }
}
