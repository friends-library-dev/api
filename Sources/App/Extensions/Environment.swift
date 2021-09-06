import Vapor

extension Environment {
  static let PG_DUMP_PATH = get("PG_DUMP_PATH")!
  static let GZIP_PATH = get("GZIP_PATH")!
  static let SENDGRID_API_KEY = get("SENDGRID_API_KEY")!
  static let DATABASE_NAME = get("DATABASE_NAME")!
  static let DATABASE_USERNAME = get("DATABASE_USERNAME")!
  static let DATABASE_PASSWORD = get("DATABASE_PASSWORD")!
}
