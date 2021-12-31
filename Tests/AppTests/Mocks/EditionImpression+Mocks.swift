// auto-generated, do not edit
import NonEmpty

@testable import App

extension EditionImpression {
  static var mock: EditionImpression {
    EditionImpression(
      editionId: .init(),
      adocLength: 42,
      paperbackSize: .s,
      paperbackVolumes: NonEmpty<[Int]>(42),
      publishedRevision: "@mock publishedRevision",
      productionToolchainRevision: "@mock productionToolchainRevision"
    )
  }

  static var empty: EditionImpression {
    EditionImpression(
      editionId: .init(),
      adocLength: 0,
      paperbackSize: .s,
      paperbackVolumes: NonEmpty<[Int]>(0),
      publishedRevision: "",
      productionToolchainRevision: ""
    )
  }

  static var random: EditionImpression {
    EditionImpression(
      editionId: .init(),
      adocLength: Int.random,
      paperbackSize: PrintSizeVariant.allCases.shuffled().first!,
      paperbackVolumes: NonEmpty<[Int]>(Int.random),
      publishedRevision: .init(rawValue: "@random".random),
      productionToolchainRevision: .init(rawValue: "@random".random)
    )
  }
}
