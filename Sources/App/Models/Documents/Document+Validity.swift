extension Document {
  var isValid: Bool {
    if !title.firstLetterIsUppercase {
      return false
    }

    if !filename.firstLetterIsUppercase {
      return false
    }

    if title.count < 5 {
      return false
    }

    if !slug.match("^[a-z][a-z0-9-]+$") {
      return false
    }

    if description.containsUnpresentableSubstring {
      return false
    }

    if partialDescription.containsUnpresentableSubstring {
      return false
    }

    if featuredDescription?.containsUnpresentableSubstring == true {
      return false
    }

    if published?.isValidEarlyQuakerYear == false {
      return false
    }

    if let originalTitle = originalTitle {
      if !originalTitle.firstLetterIsUppercase {
        return false
      }

      if originalTitle.count < 7 {
        return false
      }
    }

    if case .loaded = editions, hasNonDraftEdition {
      if description.count < 5 || partialDescription.count < 5 {
        return false
      }

      if let featured = featuredDescription, featured.count < 5 {
        return false
      }
    }

    if case .loaded = friend {
      if lang == .en, !filename.match("^[A-Z][A-Za-z0-9_]+$") {
        return false
      }

      if lang == .es, filename.contains(" ") {
        return false
      }
    } else {
      if filename.contains(" ") {
        return false
      }
    }

    return true
  }
}
