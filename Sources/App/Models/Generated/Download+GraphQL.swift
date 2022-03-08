// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var DownloadType: ModelType<Download> {
    Type(Download.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("editionId", at: \.editionId.rawValue.lowercased)
      Field("format", at: \.format)
      Field("source", at: \.source)
      Field("audioQuality", at: \.audioQuality)
      Field("audioPartNumber", at: \.audioPartNumber)
      Field("isMobile", at: \.isMobile)
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
      Field("createdAt", at: \.createdAt)
      Field("edition", with: \.edition)
    }
  }

  struct CreateDownloadInput: Codable {
    let id: UUID?
    let editionId: UUID
    let format: Download.Format
    let source: Download.DownloadSource
    let audioQuality: Download.AudioQuality?
    let audioPartNumber: Int?
    let isMobile: Bool
    let userAgent: String?
    let os: String?
    let browser: String?
    let platform: String?
    let referrer: String?
    let ip: String?
    let city: String?
    let region: String?
    let postalCode: String?
    let country: String?
    let latitude: String?
    let longitude: String?
  }

  struct UpdateDownloadInput: Codable {
    let id: UUID
    let editionId: UUID
    let format: Download.Format
    let source: Download.DownloadSource
    let audioQuality: Download.AudioQuality?
    let audioPartNumber: Int?
    let isMobile: Bool
    let userAgent: String?
    let os: String?
    let browser: String?
    let platform: String?
    let referrer: String?
    let ip: String?
    let city: String?
    let region: String?
    let postalCode: String?
    let country: String?
    let latitude: String?
    let longitude: String?
  }

  static var CreateDownloadInputType: AppInput<AppSchema.CreateDownloadInput> {
    Input(AppSchema.CreateDownloadInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("format", at: \.format)
      InputField("source", at: \.source)
      InputField("audioQuality", at: \.audioQuality)
      InputField("audioPartNumber", at: \.audioPartNumber)
      InputField("isMobile", at: \.isMobile)
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
  }

  static var UpdateDownloadInputType: AppInput<AppSchema.UpdateDownloadInput> {
    Input(AppSchema.UpdateDownloadInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("format", at: \.format)
      InputField("source", at: \.source)
      InputField("audioQuality", at: \.audioQuality)
      InputField("audioPartNumber", at: \.audioPartNumber)
      InputField("isMobile", at: \.isMobile)
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
  }

  static var getDownload: AppField<Download, IdentifyEntity> {
    Field("getDownload", at: Resolver.getDownload) {
      Argument("id", at: \.id)
    }
  }

  static var getDownloads: AppField<[Download], NoArgs> {
    Field("getDownloads", at: Resolver.getDownloads)
  }

  static var createDownload: AppField<IdentifyEntity, InputArgs<CreateDownloadInput>> {
    Field("createDownload", at: Resolver.createDownload) {
      Argument("input", at: \.input)
    }
  }

  static var createDownloads: AppField<[IdentifyEntity], InputArgs<[CreateDownloadInput]>> {
    Field("createDownloads", at: Resolver.createDownloads) {
      Argument("input", at: \.input)
    }
  }

  static var updateDownload: AppField<Download, InputArgs<UpdateDownloadInput>> {
    Field("updateDownload", at: Resolver.updateDownload) {
      Argument("input", at: \.input)
    }
  }

  static var updateDownloads: AppField<[Download], InputArgs<[UpdateDownloadInput]>> {
    Field("updateDownloads", at: Resolver.updateDownloads) {
      Argument("input", at: \.input)
    }
  }

  static var deleteDownload: AppField<Download, IdentifyEntity> {
    Field("deleteDownload", at: Resolver.deleteDownload) {
      Argument("id", at: \.id)
    }
  }
}

extension Download {
  convenience init(_ input: AppSchema.CreateDownloadInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      editionId: .init(rawValue: input.editionId),
      format: input.format,
      source: input.source,
      isMobile: input.isMobile,
      audioQuality: input.audioQuality,
      audioPartNumber: input.audioPartNumber,
      userAgent: input.userAgent,
      os: input.os,
      browser: input.browser,
      platform: input.platform,
      referrer: input.referrer,
      ip: input.ip,
      city: input.city,
      region: input.region,
      postalCode: input.postalCode,
      country: input.country,
      latitude: input.latitude,
      longitude: input.longitude
    )
  }

  convenience init(_ input: AppSchema.UpdateDownloadInput) {
    self.init(
      id: .init(rawValue: input.id),
      editionId: .init(rawValue: input.editionId),
      format: input.format,
      source: input.source,
      isMobile: input.isMobile,
      audioQuality: input.audioQuality,
      audioPartNumber: input.audioPartNumber,
      userAgent: input.userAgent,
      os: input.os,
      browser: input.browser,
      platform: input.platform,
      referrer: input.referrer,
      ip: input.ip,
      city: input.city,
      region: input.region,
      postalCode: input.postalCode,
      country: input.country,
      latitude: input.latitude,
      longitude: input.longitude
    )
  }

  func update(_ input: AppSchema.UpdateDownloadInput) {
    editionId = .init(rawValue: input.editionId)
    format = input.format
    source = input.source
    audioQuality = input.audioQuality
    audioPartNumber = input.audioPartNumber
    isMobile = input.isMobile
    userAgent = input.userAgent
    os = input.os
    browser = input.browser
    platform = input.platform
    referrer = input.referrer
    ip = input.ip
    city = input.city
    region = input.region
    postalCode = input.postalCode
    country = input.country
    latitude = input.latitude
    longitude = input.longitude
  }
}
