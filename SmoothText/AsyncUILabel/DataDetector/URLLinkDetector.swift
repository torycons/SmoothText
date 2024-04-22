//
//  URLLinkDetector.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 22/4/2567 BE.
//

import Foundation

struct URLLinkDetector: LabelTextDetector {
  let checkingResultType: NSTextCheckingResult.CheckingType
  let linkAttributed: [NSAttributedString.Key: Any]

  struct LinkData {
    public let attributes: [NSAttributedString.Key: Any]
    public let result: NSTextCheckingResult?
  }

  init(checkingResultType: NSTextCheckingResult.CheckingType, linkAttributed: [NSAttributedString.Key: Any]) {
    self.checkingResultType = checkingResultType
    self.linkAttributed = linkAttributed
  }

  func detect(data: LabelTextDetectorData) -> LabelTextDetectorData {
    do {
      let dataDetector = try NSDataDetector(types: checkingResultType.rawValue)
      let detectorResult = dataDetector.matches(
        in: data.attributedText.string,
        options: [],
        range: data.attributedText.fullRange)
      guard !detectorResult.isEmpty else { return data }
      return self.addLinks(
        originalAttributedString: data.attributedText,
        textCheckingResults: detectorResult,
        withAttributes: linkAttributed)
    } catch {
      return data
    }
  }

  private func addLinks(
    originalAttributedString: NSAttributedString,
    textCheckingResults: [NSTextCheckingResult],
    withAttributes attributes: [NSAttributedString.Key: Any]) -> LabelTextDetectorData {
    var links: [LinkData] = []
    for result in textCheckingResults {
      var text = originalAttributedString.string
      if let range = Range(result.range, in: text) {
        text = String(text[range])
      }
      let link = LinkData(attributes: attributes, result: result)
      links.append(link)
    }
    return addLinks(originalAttributedString: originalAttributedString, links: links)
  }

  private func addLinks(originalAttributedString: NSAttributedString, links: [LinkData]) -> LabelTextDetectorData {
    guard let attributedText = originalAttributedString.mutableCopy() as? NSMutableAttributedString else {
      return .init(attributedText: originalAttributedString, urlRanges: [])
    }

    var urlRanges: [NSRange] = []

    for link in links {
      let attributes = link.attributes
      guard let range = link.result?.range else {
        continue
      }
      attributedText.addAttributes(attributes, range: range)

      if let linkResult = link.result {
        switch linkResult.resultType {
        case .link, .phoneNumber:
          if let url = linkResult.url {
            attributedText.addAttribute(.link, value: url, range: range)
            urlRanges.append(range)
          }
        default: break
        }
      }
    }
    return .init(attributedText: attributedText, urlRanges: urlRanges)
  }
}
