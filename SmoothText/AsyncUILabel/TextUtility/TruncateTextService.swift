//
//  TruncateTextService.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 22/4/2567 BE.
//

import Foundation
import CoreText

struct TruncateTextService {
  let trailingTextAttributes: [NSAttributedString.Key : Any]

  init(trailingTextAttributes: [NSAttributedString.Key : Any]) {
    self.trailingTextAttributes = trailingTextAttributes
  }

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

  func insertTruncateText(textData: AsyncUILabel.TextData, numberOfLines: Int) -> AsyncUILabel.TextData {
    guard numberOfLines > 0, textData.numberOfLines > 0 else { return textData }
    let originalLineCount = getNumberOfLines(attrString: textData.attrString, viewWidth: textData.viewWidth)
    if numberOfLines >= originalLineCount { return textData }

    let mutableTruncateString = NSMutableAttributedString(string: "\u{2026}", attributes: trailingTextAttributes)
    if let customTrailing = textData.customTrailing {
      mutableTruncateString.append(NSAttributedString(string: customTrailing.style.title, attributes: customTrailing.textAttributes))
    }
    var newAttrString = NSMutableAttributedString(attributedString: textData.attrString)
      .clearExcessiveCharacter()
      .trimLastNewLine()
    let textLimit = truncateLimitLength(attrString: newAttrString, viewWidth: textData.viewWidth, maxLine: textData.numberOfLines)
    let slicedStr = newAttrString.attributedSubstring(from: NSMakeRange(0, textLimit))
    newAttrString = NSMutableAttributedString(attributedString: slicedStr)


    var newTextLineCount = getNumberOfLines(attrString: newAttrString + mutableTruncateString, viewWidth: textData.viewWidth)
    while newTextLineCount > numberOfLines {
      let slicedStr = newAttrString.attributedSubstring(from: NSMakeRange(0, newAttrString.length - 1))
      newAttrString = NSMutableAttributedString(attributedString: slicedStr)
      newTextLineCount = getNumberOfLines(attrString: newAttrString + mutableTruncateString, viewWidth: textData.viewWidth)
    }

    let attrString = newAttrString + mutableTruncateString
    let textSize = attrString.frameSize(width: textData.viewWidth)
    let textFrame = getCTFrame(attrString: attrString, textSize: textSize)

    return AsyncUILabel.TextData(
      attrString: attrString,
      viewWidth: textData.viewWidth,
      numberOfLines: numberOfLines,
      textFrame: textFrame,
      textSize: textSize,
      customTrailing: textData.customTrailing)
  }


  func truncateLimitLength(attrString: NSAttributedString, viewWidth: CGFloat, maxLine: Int) -> Int {
    let lines = getLines(attrString: attrString, viewWidth: viewWidth)
    var limitLength = 0
    if maxLine > 0 && lines.count > 0 {
      for i in 0...(min(lines.count - 1, maxLine - 1)) {
        let line = lines[i]
        let range = CTLineGetStringRange(line)
        limitLength += range.length
      }
    }
    else {
      limitLength = attrString.length
    }
    return limitLength
  }

  private func getLines(attrString: NSAttributedString, viewWidth: CGFloat) -> [CTLine] {
    let textSize = attrString.frameSize(width: viewWidth)
    let path = CGMutablePath()
    path.addRect(CGRect(origin: .zero, size: textSize))
    let truncateFramesetter = CTFramesetterCreateWithAttributedString(attrString)
    let truncateFrame = CTFramesetterCreateFrame(truncateFramesetter, CFRange(location: 0, length: attrString.length), path, nil)
    return (CTFrameGetLines(truncateFrame) as? Array<CTLine>) ?? []
  }

  private func getNumberOfLines(attrString: NSAttributedString, viewWidth: CGFloat) -> Int {
    return getLines(attrString: attrString, viewWidth: viewWidth).count
  }

  private func getCTFrame(attrString: NSAttributedString, textSize: CGSize) -> CTFrame {
    let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
    let path = CGMutablePath()
    path.addRect(CGRect(origin: .zero, size: textSize))
    return CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
  }
}


extension NSMutableAttributedString {
  fileprivate func clearExcessiveCharacter() -> NSMutableAttributedString {
    let regex = "[\\. ]*$"
    guard let range = string.range(of: regex, options: .regularExpression, range: nil, locale: nil) else { return self }
    let str = string
    mutableString.replaceCharacters(in: NSRange(range, in: str), with: "")
    return self
  }

  fileprivate func trimLastNewLine() -> NSMutableAttributedString {
    if string.last == "\n" {
      let slicedStr = attributedSubstring(from: NSMakeRange(0, self.length - 1))
      return NSMutableAttributedString(attributedString: slicedStr)
    } else {
      return self
    }
  }
}

extension NSAttributedString {
  func frameSize(width: CGFloat) -> CGSize {
    let framesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
    let cfRange = CFRangeMake(0, self.string.utf16.count)
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, cfRange, nil, size, nil)
  }
}

public extension NSMutableAttributedString {
  static func +(lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
    let str = NSMutableAttributedString(attributedString: lhs)
    str.append(rhs)
    return str
  }
}
