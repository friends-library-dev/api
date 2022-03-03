import Vapor

func logAndRedirect(
  file: DownloadableFile,
  userAgent: String,
  ipAddress: String? = nil,
  referrer: String? = nil
) async throws -> Response {
  let response = Response()
  response.status = RedirectType.temporary.status
  response.headers.replaceOrAdd(name: .location, value: file.sourceUrl.absoluteString)

  let isAppUserAgent = userAgent.contains("FriendsLibrary")
  var source: Download.DownloadSource = isAppUserAgent ? .app : .website

  switch (userAgent |> isPodcast, file.format) {
    case (true, _), (_, .audio(.podcast)):
      source = .podcast
      response.status = RedirectType.permanent.status
    default:
      break
  }

  guard let device = UserAgentDeviceData(userAgent: userAgent) else {
    await slackError("Failed to parse user agent `\(userAgent)` into device data")
    return response
  }

  if !isAppUserAgent, device.isBot == true {
    await slackDebug("Bot download: `\(userAgent)`")
    return response
  }

  guard let downloadFormat = file.format.downloadFormat else {
    await slackError("Unexpected download format: \(file.format)")
    return response
  }

  let download = Download(
    editionId: file.edition.id,
    format: downloadFormat,
    source: source,
    isMobile: device.isMobile,
    audioQuality: file.format.audioQuality,
    audioPartNumber: file.format.audioPartNumber,
    userAgent: userAgent.isEmpty ? nil : userAgent,
    os: device.os,
    browser: device.browser,
    platform: device.platform,
    referrer: referrer,
    ip: ipAddress
  )

  var location: IpApi.Response?
  if let ip = ipAddress, shouldQueryLocation(file.format) {
    do {
      location = try await Current.ipApiClient.getIpData(ip)
      download.city = location?.city
      download.region = location?.region
      download.postalCode = location?.postal
      download.latitude = location?.latitude.map { String($0) }
      download.longitude = location?.longitude.map { String($0) }
    } catch {
      await slackError("Error fetching download location data: \(error)")
    }
  }

  do {
    try await Current.db.create(download)
    await slackDownload(file: file, location: location, device: device, referrer: referrer)
  } catch {
    await slackError("Error creating download: \(error)")
  }

  return response
}

func downloadFileRouteHandler(req: Request) async throws -> Response {
  struct RefererQuery: Content { let referer: String? }
  let query = try? req.query.decode(RefererQuery.self)
  var path = req.url.path
  path.removeFirst()
  do {
    return try await logAndRedirect(
      file: try await DownloadableFile(logPath: path),
      userAgent: req.headers.first(name: .userAgent) ?? "",
      ipAddress: req.ipAddress,
      referrer: query?.referer ?? req.headers.first(name: .referer)
    )
  } catch {
    var errorMsg = "Failed to resolve Downloadable file from path: \(path), error: \(error)"
    if let parseErr = error as? DownloadableFile.ParseLogPathError {
      let errorDesc = parseErr.errorDescription ?? String(describing: parseErr)
      errorMsg = "Failed to resolve DownloadableFile: \(errorDesc)"
    }
    await slackError(errorMsg)
    return Response(status: .notFound, body: .init(string: "<h1>Not Found</h1>"))
  }
}

// private helpers

private func slackDownload(
  file: DownloadableFile,
  location: IpApi.Response?,
  device: UserAgentDeviceData,
  referrer: String?
) async {
  var from = ""
  if let referrer = referrer {
    from = ", from url: `\(unUrl(referrer))`"
  }

  var place = ""
  if let location = location {
    place = ", location: `\(location.slackSummary)` \(location.mapUrl ?? "")"
  }

  await Current.slackClient.send(.init(
    text: "Download: `\(file.edition.directoryPath)/\(file.filename)`, device: `\(device.slackSummary)`\(from)\(place)",
    channel: file.format.slackChannel
  ))
}

private extension IpApi.Response {
  var slackSummary: String {
    [city, region, postal, countryName].compactMap { $0 }.joined(separator: " / ")
  }

  var mapUrl: String? {
    guard let latitude = latitude, let longitude = longitude else {
      return nil
    }
    return "https://www.google.com/maps/@\(latitude),\(longitude),14z"
  }
}

private extension UserAgentDeviceData {
  var slackSummary: String {
    [platform, os, browser, isMobile ? "mobile" : "non-mobile"]
      .compactMap { $0 }
      .filter { $0 != "unknown" }
      .joined(separator: " / ")
  }
}

private func unUrl(_ referrer: String) -> String {
  referrer.replace(#"^https:\/\/www\.([^/]+)"#, "[$1]")
}

private func shouldQueryLocation(_ format: DownloadableFile.Format) -> Bool {
  guard Env.mode == .prod || Env.mode == .test else {
    return false
  }

  guard case .audio(.podcast) = format else {
    return true
  }

  // sample only 5% of podcast request, to stay in api rate limits without paid acct
  return Int.random(in: 0 ... 100) < 5
}

func isPodcast(userAgent: String) -> Bool {
  userAgent
    .lowercased()
    .match("(podcast|stitcher|tunein|audible|spotify|pocketcasts|overcast|castro|castbox)")
}
