//
//  AsyncUILabel+Utility.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import CoreText

private let textDataQueue = DispatchQueue(label: "com.smoothText.textData")

extension AsyncUILabel {
  final class TextUtility {
    private let cache: AsyncUILabelTextCache
    private let link: AsyncUILabelLink

    static let shared: TextUtility = TextUtility()
  
    init(
      cache: AsyncUILabelTextCache = TextCache(),
      link: AsyncUILabelLink = TextLink()) {
      self.cache = cache
      self.link = link
    }

    func detectLinkAndUpdateCacheData(
      string: String,
      checkingResultType: NSTextCheckingResult.CheckingType,
      width: CGFloat) -> NSAttributedString {
      return detectLinkAndUpdateCacheData(
        attributedString: NSAttributedString(string: string),
        checkingResultType: checkingResultType,
        width: width)
    }

    func detectLinkAndUpdateCacheData(
      attributedString: NSAttributedString,
      checkingResultType: NSTextCheckingResult.CheckingType,
      width: CGFloat) -> NSAttributedString {
      let deltectedString = link.detectLinks(
        attributedText: attributedString,
        checkingResultType: checkingResultType)
      return updateTextData(attrString: deltectedString, width: width).attrString
    }

    func updateTextData(attrString: NSAttributedString, width: CGFloat) -> AsyncUILabel.TextData {
      let size = self.calculateFrameSize(attrString: attrString, width: width)
      let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
      let path = CGMutablePath()
      path.addRect(CGRect(origin: .zero, size: size))
      let ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
      let textData = TextData(attrString: attrString, width: width, frame: ctFrame, size: size)
      self.cache.update(key: attrString, width: width, textData: textData)
      return textData
    }

    func getTextData(attrString: NSAttributedString, width: CGFloat, completion: ((AsyncUILabel.TextData) -> Void)?) -> AsyncUILabel.TextData? {
      if let data = self.cache.get(key: attrString, width: width) {
        return data
      } else {
        textDataQueue.async { [weak self] in
          guard let self else { return }
          let textData = self.updateTextData(attrString: attrString, width: width)
          DispatchQueue.main.async {
            completion?(textData)
          }
        }
        return nil
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
