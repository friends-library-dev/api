import Fluent

struct CreateOrderItems: Migration {
  func prepare(on database: Database) -> Future<Void> {

    return database.enum("edition_type").read()
      .flatMap { editionType in
        return database.schema("order_items")
          .id()
          .field(
            "order_id",
            .uuid,
            .required,
            .references("orders", "id", onDelete: .cascade)
          )
          .field("title", .string, .required)
          .field("document_id", .uuid, .required)
          .field("edition_type", editionType, .required)
          .field("quantity", .int, .required)
          .field("unit_price", .int, .required)
          .field("created_at", .datetime, .required)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema("order_items").delete()
  }
}
