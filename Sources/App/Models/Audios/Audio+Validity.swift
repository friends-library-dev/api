extension Audio {
  var isValid: Bool {
    if reader.isEmpty {
      Current.logger.warning("Invalid audio: reader is empty")
      return false
    }

    if mp3ZipSizeLq != 0, mp3ZipSizeLq < 2000000 {
      Current.logger.warning("Invalid audio: mp3ZipSizeLq is too small: \(mp3ZipSizeLq)")
      return false
    }

    if mp3ZipSizeHq != 0, mp3ZipSizeHq < 5000000 {
      Current.logger.warning("Invalid audio: mp3ZipSizeHq is too small: \(mp3ZipSizeHq)")
      return false
    }

    if m4bSizeLq != 0, m4bSizeLq < 3000000 {
      Current.logger.warning("Invalid audio: m4bSizeLq is too small: \(m4bSizeLq)")
      return false
    }

    if m4bSizeHq != 0, m4bSizeHq < 8000000 {
      Current.logger.warning("Invalid audio: m4bSizeHq is too small: \(m4bSizeHq)")
      return false
    }

    if m4bSizeLq >= m4bSizeHq, m4bSizeLq != 0 {
      Current.logger.warning("Invalid audio: m4bSizeLq is greater than m4bSizeHq: \(m4bSizeLq)")
      return false
    }

    if mp3ZipSizeLq >= mp3ZipSizeHq, mp3ZipSizeLq != 0 {
      Current.logger
        .warning("Invalid audio: mp3ZipSizeLq is greater than mp3ZipSizeHq: \(mp3ZipSizeLq)")
      return false
    }

    if externalPlaylistIdLq == nil, externalPlaylistIdHq != nil {
      Current.logger
        .warning("Invalid audio: externalPlaylistIdLq is nil, but externalPlaylistIdHq is not nil")
      return false
    }

    if externalPlaylistIdHq == nil, externalPlaylistIdLq != nil {
      Current.logger
        .warning("Invalid audio: externalPlaylistIdHq is nil, but externalPlaylistIdLq is not nil")
      return false
    }

    let isPublished = m4bSizeHq != 0

    if isPublished, let extLq = externalPlaylistIdLq, extLq < 900000000 {
      Current.logger
        .warning("Invalid audio: isPublished and externalPlaylistIdLq is too small: \(extLq)")
      return false
    }

    if isPublished, let extHq = externalPlaylistIdHq, extHq < 900000000 {
      Current.logger
        .warning("Invalid audio: isPublished and externalPlaylistIdHq is too small: \(extHq)")
      return false
    }

    // test for sequential parts, when loaded
    if case .loaded(let parts) = parts {
      let sorted = parts.sorted { $0.order < $1.order }
      var prev = 0
      for part in sorted {
        if part.order != prev + 1 {
          Current.logger.warning("Invalid audio: part order is not sequential: \(part.order)")
          return false
        }
        prev = part.order
      }
    }

    return true
  }
}
