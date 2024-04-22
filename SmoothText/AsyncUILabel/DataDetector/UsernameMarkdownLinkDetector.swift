//
//  UsernameMarkdownLinkDetector.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 22/4/2567 BE.
//

import Foundation
import UIKit

struct UsernameMarkdownLinkDetector: LabelTextDetector {
  let linkAttributed: [NSAttributedString.Key : Any]

  init(linkAttributed: [NSAttributedString.Key : Any]) {
    self.linkAttributed = linkAttributed
  }

  func detect(data: LabelTextDetectorData) -> LabelTextDetectorData {
    let usernameTag = "username"
    let urlTag = "url"
    let pattern = "\\[(?<\(usernameTag)>[^\r\n\\]]+)\\]\\((?<\(urlTag)>[^\r\n\\s\\)]+)\\)"
    let text = NSMutableAttributedString(attributedString: data.attributedText)
    var urlRanges = data.urlRanges
    do {
      let detector = try NSRegularExpression(pattern: pattern)
      let matches = detector.matches(in: text.string, options: [], range: NSRange(location: 0, length: text.string.utf16.count))
      for match in matches.reversed() {
        let currentString = text.string
        var url: URL? = nil
        let nsRangeURL = match.range(withName: urlTag)
        if let matchURL = text.attribute(NSAttributedString.Key.link, at: nsRangeURL.location, effectiveRange: nil) as? URL {
          url = matchURL
          urlRanges.removeAll(where: { $0 == nsRangeURL })
        }
        if let usernameRange = Range(match.range(withName: usernameTag), in: currentString) {
          let username = String(currentString[usernameRange])
          let newUsernameAttr = NSMutableAttributedString(string: username, attributes: linkAttributed)
          if let url {
            newUsernameAttr.addAttributes([
              .link : url,
            ], range: newUsernameAttr.fullRange)
          }
          text.replaceCharacters(in: match.range, with: newUsernameAttr)
        }
      }
      return .init(attributedText: text, urlRanges: urlRanges)
    } catch {
      return data
    }
  }
}

public extension NSAttributedString {
  var fullRange: NSRange {
    return NSRange(location: 0, length: length)
  }
}
