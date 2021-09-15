import Fluent
import Foundation

@testable import App

extension Order {
  static func createFixture(on db: Database, customize: ((Order) -> Void)? = nil) -> Order {
    let order = Order()
    order.paymentId = "@test-paymentId"
    order.printJobStatus = .presubmit
    order.amount = 111
    order.shipping = 16
    order.taxes = 0
    order.ccFeeOffset = 6
    order.shippingLevel = .mail
    order.email = "test@test.com"
    order.addressName = "Jane Doe"
    order.addressStreet = "123 Magnolia Lane"
    order.addressCity = "Wadsworth"
    order.addressState = "OH"
    order.addressZip = "44281"
    order.addressCountry = "US"
    order.lang = .en
    order.source = .website
    if let customize = customize {
      customize(order)
    }
    try! order.create(on: db).wait()

    let item = OrderItem()
    item.title = "Journal of George Fox"
    item.documentId = UUID()
    item.editionType = .original
    item.quantity = 1
    item.unitPrice = 123
    try! order.$items.create(item, on: db).wait()

    return order
  }
}

extension FreeOrderRequest {
  static func createFixture(
    on db: Database,
    customize: ((FreeOrderRequest) -> Void)? = nil
  ) -> FreeOrderRequest {
    let request = FreeOrderRequest()
    request.email = "test@test.com"
    request.name = "Jane Doe"
    request.requestedBooks = "La Senda Antiqua"
    request.aboutRequester = "not a freebie hunter"
    request.addressStreet = "123 Magnolia Lane"
    request.addressCity = "Wadsworth"
    request.addressState = "OH"
    request.addressZip = "44281"
    request.addressCountry = "US"
    request.source = "la-senda-antigua"
    if let customize = customize {
      customize(request)
    }
    try! request.create(on: db).wait()
    return request
  }
}
