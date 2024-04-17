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
    private let link: AsyncUILabelLink
  
    init(
      cache: AsyncUILabelTextCache = TextCache(),
      link: AsyncUILabelLink = TextLink()) {
      self.cache = cache
      self.link = link
    }

    func detectLinkAndUpdateCacheData(
      attributedString: NSAttributedString,
      checkingResultType: NSTextCheckingResult.CheckingType,
      numberOfLines: Int,
      customTrailing: CustomTrailling?,
      width: CGFloat) -> NSAttributedString {
      let deltectedString = link.detectLinks(
        attributedText: attributedString,
        checkingResultType: checkingResultType)
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
      let textData = TextData(attrString: attrString, viewFullWidth: width, textFrame: ctFrame, textSize: size, customTrailing: customTrailing)
//      let lines = (CTFrameGetLines(ctFrame) as? Array<CTLine>) ?? []
//      var textData = TextData(
//        attrString: attrString,
//        viewFullWidth: width,
//        coreTextLines: lines,
//        textSize: size,
//        customTrailing: customTrailing)
//
//      if numberOfLines > 0 {
//        textData = truncateLinesIfNeeded(textData: textData, numberOfLines: numberOfLines, path: path)
//      }

      self.cache.update(key: attrString, width: width, textData: textData)
      return textData
    }

//    func truncateLinesIfNeeded(textData: TextData, numberOfLines: Int, path: CGMutablePath) -> TextData {
//      guard numberOfLines > 0, textData.coreTextLines.count > 0 else { return textData }
//
//      let mutableTruncateString = NSMutableAttributedString(string: "\u{2026}", attributes: [.font: UIFont.systemFont(ofSize: 15)])
//      if let customTrailing = textData.customTrailing {
//        mutableTruncateString.append(NSAttributedString(string: customTrailing.style.title, attributes: customTrailing.textAttributes))
//      }
//      
//      let truncateFramesetter = CTFramesetterCreateWithAttributedString(mutableTruncateString)
//      let truncateFrame = CTFramesetterCreateFrame(truncateFramesetter, CFRange(location: 0, length: mutableTruncateString.length), path, nil)
//      let truncateLines = (CTFrameGetLines(truncateFrame) as? Array<CTLine>) ?? []
//
//      var lines = textData.coreTextLines
//
//      for (index, truncateLine) in truncateLines.enumerated() {
//        let originalIndex = numberOfLines - truncateLines.count + index
//        let truncatedLine = CTLineCreateTruncatedLine(lines[originalIndex], textData.textSize.width, .end, truncateLine) ?? truncateLine
//        lines[originalIndex] = truncatedLine
//      }
//
//      return TextData(
//        attrString: textData.attrString,
//        viewFullWidth: textData.viewFullWidth,
//        coreTextLines: lines,
//        textSize: textData.textSize,
//        customTrailing: textData.customTrailing)
//    }

    func getTextData(attrString: NSAttributedString, numberOfLines: Int, customTrailing: CustomTrailling?, width: CGFloat) -> AsyncUILabel.TextData {
      if let data = cache.get(key: attrString, width: width) {
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
