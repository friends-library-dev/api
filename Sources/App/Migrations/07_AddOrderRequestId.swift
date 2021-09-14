import Fluent
import Vapor

struct AddOrderRequestId: Migration {

  func prepare(on database: Database) -> Future<Void> {
    database.schema(Order.M2.tableName)
      .field(
        Order.M7.freeOrderRequestId,
        .uuid,
        .references(
          FreeOrderRequest.M6.tableName,
          FreeOrderRequest.M6.id,
          onDelete: .setNull
        )
      )
      .update()
  }

  func revert(on database: Database) -> Future<Void> {
    database.schema(Order.M2.tableName)
      .deleteField(Order.M7.freeOrderRequestId)
      .update()
  }
}
