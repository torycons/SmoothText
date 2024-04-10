//
//  AsyncUILabel+Links.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import UIKit

protocol AsyncUILabelLink {
  func detectLinks(attributedText: NSAttributedString, checkingResultType: NSTextCheckingResult.CheckingType) -> NSAttributedString
}

extension AsyncUILabel {
  class TextLink: AsyncUILabelLink {
    struct LinkData {
      public let attributes: [NSAttributedString.Key: Any]
      public let result: NSTextCheckingResult?
    }

    func detectLinks(attributedText: NSAttributedString, checkingResultType: NSTextCheckingResult.CheckingType) -> NSAttributedString {
      do {
        let dataDetector = try NSDataDetector(types: checkingResultType.rawValue)
        let detectorResult = dataDetector.matches(
          in: attributedText.string,
          options: [],
          range: NSRange(location: 0, length: attributedText.length))
        guard !detectorResult.isEmpty else { return attributedText }
        return self.addLinks(
          originalAttributedString: attributedText,
          textCheckingResults: detectorResult,
          withAttributes: [.foregroundColor: UIColor.red])
      } catch {
        return attributedText
      }
    }

    private func addLinks(
      originalAttributedString: NSAttributedString,
      textCheckingResults: [NSTextCheckingResult],
      withAttributes attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
      var links: [LinkData] = []
      for result in textCheckingResults {
        var text = originalAttributedString.string
        if let range = Range(result.range, in: text) {
          text = String(text[range])
        }
        let link = LinkData(attributes: attributes ?? [:], result: result)
        links.append(link)
      }
      return addLinks(originalAttributedString: originalAttributedString, links: links)
    }

    private func addLinks(originalAttributedString: NSAttributedString, links: [LinkData]) -> NSAttributedString {
      guard let attributedText = originalAttributedString.mutableCopy() as? NSMutableAttributedString else {
        return originalAttributedString
      }

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
            }
          default: break
          }
        }
      }
      return attributedText
    }
  }
}
