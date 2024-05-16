//
//  AsyncUILabel+Utility.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import CoreText
import UIKit

extension AsyncUILabel {
  struct CustomTrailling {
    enum Style {
      case seeMore
      case continueReading

      var title: String {
        switch self {
        case .seeMore:
          return "See More"
        case .continueReading:
          return "Continue Raeading"
        }
      }
    }

    let textAttributes: [NSAttributedString.Key: Any]
    let style: Style
  }

  final class TextUtility {
    private let cache: AsyncUILabelTextCache
    private let dataDetector: TextDataDetectorService
    private let truncate = TruncateTextService(trailingTextAttributes: [.foregroundColor: UIColor.blue])

    init(
      cache: AsyncUILabelTextCache = TextCache(),
      dataDetector: TextDataDetectorService = TextDataDetectorServiceImp(detectors: [
        URLLinkDetector(checkingResultType: .link, linkAttributed: [.foregroundColor: UIColor.red]),
//        UsernameMarkdownLinkDetector(linkAttributed: [.foregroundColor: UIColor.red])
      ])) {
      self.cache = cache
      self.dataDetector = dataDetector
    }

    func detectLinkAndUpdateCacheData(
      attributedString: NSAttributedString,
      numberOfLines: Int,
      customTrailing: CustomTrailling?,
      width: CGFloat) -> NSAttributedString {
      let deltectedString = dataDetector.detect(attributedText: attributedString)
      return updateTextData(
        attrString: deltectedString,
        numberOfLines: numberOfLines,
        customTrailing: customTrailing,
        width: width).attrString
    }

    func updateTextData(
      attrString: NSAttributedString,
      numberOfLines: Int,
      customTrailing: CustomTrailling?,
      width: CGFloat) -> AsyncUILabel.TextData {
      let size = self.calculateFrameSize(attrString: attrString, width: width)
      let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
      let path = CGMutablePath()
      path.addRect(CGRect(origin: .zero, size: size))
      let ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
      var textData = TextData(
        attrString: attrString,
        viewWidth: width,
        numberOfLines: numberOfLines,
        textFrame: ctFrame,
        textSize: size,
        customTrailing: customTrailing)
      textData = truncate.insertTruncateText(
        textData: textData,
        numberOfLines: numberOfLines)

      if (0...max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)).contains(width) {
        self.cache.update(key: attrString, width: width, textData: textData)
      }

      return textData
    }

    func getTextData(attrString: NSAttributedString, numberOfLines: Int, customTrailing: CustomTrailling?, width: CGFloat) -> AsyncUILabel.TextData {
      if let data = cache.get(key: attrString, width: width, numberOfLines: numberOfLines) {
        return data
      } else {
        return updateTextData(
          attrString: attrString,
          numberOfLines: numberOfLines,
          customTrailing: customTrailing,
          width: width)
      }
    }

    private func calculateFrameSize(attrString: NSAttributedString, width: CGFloat) -> CGSize {
      let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
      let cfRange = CFRangeMake(0, attrString.string.utf16.count)
      let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
      return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, cfRange, nil, size, nil)
    }
  }
}
