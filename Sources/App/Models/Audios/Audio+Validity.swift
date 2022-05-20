extension Audio {
  var isValid: Bool {
    if reader.isEmpty {
      return false
    }

    if mp3ZipSizeLq != 0, mp3ZipSizeLq < 2000000 {
      return false
    }

    if mp3ZipSizeHq != 0, mp3ZipSizeHq < 5000000 {
      return false
    }

    if m4bSizeLq != 0, m4bSizeLq < 3000000 {
      return false
    }

    if m4bSizeHq != 0, m4bSizeHq < 8000000 {
      return false
    }

    if m4bSizeLq >= m4bSizeHq, m4bSizeLq != 0 {
      return false
    }

    if mp3ZipSizeLq >= mp3ZipSizeHq, mp3ZipSizeLq != 0 {
      return false
    }

    if externalPlaylistIdLq == nil, externalPlaylistIdHq != nil {
      return false
    }

    if externalPlaylistIdHq == nil, externalPlaylistIdLq != nil {
      return false
    }

    let isPublished = m4bSizeHq != 0

    if isPublished, let extLq = externalPlaylistIdLq, extLq < 900000000 {
      return false
    }

    if isPublished, let extHq = externalPlaylistIdHq, extHq < 900000000 {
      return false
    }

    // test for sequential parts, when loaded
    if case .loaded(let parts) = parts {
      let sorted = parts.sorted { $0.order < $1.order }
      var prev = 0
      for part in sorted {
        if part.order != prev + 1 {
          return false
        }
        prev = part.order
      }
    }

    return true
  }
}
