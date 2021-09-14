import Fluent

struct CreateOrders: Migration {
  func prepare(on database: Database) -> Future<Void> {
    let printJobStatusFuture = database.enum("order_print_job_status")
      .case("presubmit")
      .case("pending")
      .case("accepted")
      .case("rejected")
      .case("shipped")
      .case("canceled")
      .case("bricked")
      .create()

    let shippingLevelFuture = database.enum("order_shipping_level")
      .case("mail")
      .case("priorityMail")
      .case("groundHd")
      .case("ground")
      .case("expedited")
      .case("express")
      .create()

    let langFuture = database.enum("lang")
      .case("en")
      .case("es")
      .create()

    let sourceFuture = database.enum("order_source")
      .case("website")
      .case("internal")
      .create()

    return
      printJobStatusFuture
      .and(shippingLevelFuture)
      .and(langFuture)
      .and(sourceFuture)
      .flatMap { types in
        let (((printJobStatus, shippingLevel), lang), source) = types
        return database.schema(Order.M2.tableName)
          .id()
          .field(Order.M2.paymentId, .string, .required)
          .field(Order.M2.printJobStatus, printJobStatus, .required)
          .field(Order.M2.printJobId, .int)
          .field(Order.M2.amount, .int, .required)
          .field(Order.M2.shipping, .int, .required)
          .field(Order.M2.taxes, .int, .required)
          .field(Order.M2.ccFeeOffset, .int, .required)
          .field(Order.M2.shippingLevel, shippingLevel, .required)
          .field(Order.M2.email, .string, .required)
          .field(Order.M2.addressName, .string, .required)
          .field(Order.M2.addressStreet, .string, .required)
          .field(Order.M2.addressStreet2, .string)
          .field(Order.M2.addressCity, .string, .required)
          .field(Order.M2.addressState, .string, .required)
          .field(Order.M2.addressZip, .string, .required)
          .field(Order.M2.addressCountry, .string, .required)
          .field(Order.M2.lang, lang, .required)
          .field(Order.M2.source, source, .required)
          .field(FieldKey.createdAt, .datetime, .required)
          .field(FieldKey.updatedAt, .datetime, .required)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(Order.M2.tableName).delete()
  }
}
