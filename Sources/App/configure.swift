import Fluent
import FluentPostgresDriver
import GraphQLKit
import QueuesFluentDriver
import Vapor
import VaporUtils

typealias Future = EventLoopFuture
typealias Env = Vapor.Environment
typealias Req = Vapor.Request
typealias NoArgs = Graphiti.NoArguments

public func configure(_ app: Application) throws {
  app.middleware.use(corsMiddleware(app), at: .beginning)

  let dbPrefix = app.environment == .testing ? "TEST_" : ""
  app.databases.use(
    .postgres(
      hostname: Env.get("DATABASE_HOST") ?? "localhost",
      port: Env.get("DATABASE_PORT").flatMap(Int.init(_:))
        ?? PostgresConfiguration.ianaPortNumber,
      username: Env.DATABASE_USERNAME,
      password: Env.DATABASE_PASSWORD,
      database: Env.get("\(dbPrefix)DATABASE_NAME")!
    ),
    as: .psql
  )

  addMigrations(to: app)

  Current.db = LiveDatabase(db: app.db as! SQLDatabase)
  Current.logger = app.logger

  app
    .grouped(UserAuthenticator())
    .register(graphQLSchema: appSchema, withResolver: Resolver())

  if app.environment == .production {
    try configureScheduledJobs(app)
  }

  if app.environment != .production {
    try app.autoMigrate().wait()
  }

  app.logger.notice("App environment is `\(app.environment.name)`")
}

private func addMigrations(to app: Application) {
  app.migrations.add(CreateDownloads())
  app.migrations.add(CreateOrders())
  app.migrations.add(CreateOrderItems())
  app.migrations.add(CreateTokens())
  app.migrations.add(CreateTokenScopes())
  app.migrations.add(CreateFreeOrderRequests())
  app.migrations.add(AddOrderRequestId())
  app.migrations.add(CreateArtifactProductionVersion())
  app.migrations.add(AddMutateArtifactProductionVersionScope())
  app.migrations.add(HandleEditionIds())
  app.migrations.add(CreateFriends())
  app.migrations.add(CreateFriendResidences())
  app.migrations.add(CreateFriendQuotes())
  app.migrations.add(CreateDocuments())
  app.migrations.add(CreateTags())
  app.migrations.add(AddShippingLevelGroundBus())
  app.migrations.add(CreateEditions())
  app.migrations.add(CreateEditionImpressions())
  app.migrations.add(CreateIsbns())
  app.migrations.add(CreateAudios())
  app.migrations.add(CreateAudioParts())
  app.migrations.add(CreateEditionChapters())
  app.migrations.add(CreateRelatedDocuments())
  app.migrations.add(AddTokenScopes())
  app.migrations.add(CreateFriendResidenceDurations())
  app.migrations.add(AddEditionIdForeignKeys())

  if Env.get("SEED_DB") == "true" || app.environment == .testing {
    app.migrations.add(Seed())
  }
}

private func configureScheduledJobs(_ app: Application) throws {
  // since we're not using redis, only have one core (currently)
  // and are just doing very low frequency tasks, throttle way down
  app.queues.configuration.workerCount = 1
  app.queues.configuration.refreshInterval = .seconds(300)

  app.queues.use(.fluent(useSoftDeletes: false))

  let backupJob = BackupJob(
    appName: "FLP",
    dbName: Env.DATABASE_NAME,
    pgDumpPath: Env.PG_DUMP_PATH,
    sendGridApiKey: Env.SENDGRID_API_KEY,
    fromEmail: .init(
      email: "notifications@graphql-api.friendslibrary.com",
      name: "FLP GraphQL"
    )
  )

  app.queues.schedule(backupJob).daily().at(.midnight)

  try app.queues.startScheduledJobs()
}

private func corsMiddleware(_ app: Application) -> CORSMiddleware {
  let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: app.environment == .production
      ? .any([
        "https://orders.friendslibrary.com",
        "https://www.friendslibrary.com",
        "https://www.bibliotecadelosamigos.org",
      ]) : .all,
    allowedMethods: [.GET, .POST, .OPTIONS],
    allowedHeaders: [
      .accept,
      .authorization,
      .contentType,
      .origin,
      .xRequestedWith,
      .userAgent,
      .accessControlAllowOrigin,
      .referer,
    ]
  )
  return CORSMiddleware(configuration: corsConfiguration)
}
