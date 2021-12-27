import Fluent

extension Edition {
  enum M16 {
    static let tableName = "editions"
    static let documentId = FieldKey("document_id")
    static let type = FieldKey("type")
    static let editor = FieldKey("editor")
    static let isDraft = FieldKey("is_draft")
    static let paperbackOverrideSize = FieldKey("paperback_override_size")
    static let paperbackSplits = FieldKey("paperback_splits")
    enum PrintSizeVariantEnum {
      static let name = "print_size_variants"
      static let caseS = "s"
      static let caseM = "m"
      static let caseXl = "xl"
      static let caseXlCondensed = "xl--condensed"
    }
  }
}

extension PrintSizeVariant: PostgresEnum {
  var dataType: String {
    Edition.M16.PrintSizeVariantEnum.name
  }
}