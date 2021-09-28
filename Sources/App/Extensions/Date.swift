import Foundation

extension Date {
  static func createByAdding(days numDays: Int, to begin: Date) -> Date {
    let calendar = Calendar.current
    let days = DateComponents(day: numDays)
    return calendar.date(byAdding: days, to: begin)!
  }

  static func fromISOString(_ string: String?) -> Date? {
    guard let string = string else {
      return nil
    }
    let formatter = cachedFormatter ?? createFormatter()
    return formatter.date(from: string)
  }

  static func fromISOString(_ string: String?, or fallback: Date) -> Date {
    return fromISOString(string) ?? fallback
  }

  init(addingDays: Int) {
    self = Date.createByAdding(days: addingDays, to: Date())
  }

  init(subtractingDays: Int) {
    self = Date.createByAdding(days: -subtractingDays, to: Date())
  }
}

private var cachedFormatter: ISO8601DateFormatter?

private func createFormatter() -> ISO8601DateFormatter {
  let formatter = ISO8601DateFormatter()
  formatter.formatOptions = [
    .withFullDate,
    .withFullTime,
    .withDashSeparatorInDate,
    .withColonSeparatorInTime,
    .withFractionalSeconds,
  ]
  cachedFormatter = formatter
  return formatter
}
