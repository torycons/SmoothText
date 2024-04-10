//
//  AsyncUILabel+Actions.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import UIKit
import CoreText

extension AsyncUILabel {
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touchLocation = touches.first?.location(in: self) else { return }
    if let stringIndex = getStringIndex(point: touchLocation) {
      activateLink(stringIndex: stringIndex)
    }
  }

  private func activateLink(stringIndex: Int?) {
    guard let stringIndex else { return }
    if let url = attributedText?.attributes(at: stringIndex, effectiveRange: nil)[.link] as? URL {
      delegate?.asynUILabel(self, didTapLinkWith: url)
    } else {
      delegate?.asynUILabel(didTapLabelWith: self)
    }
  }

  private var flushFactor: CGFloat {
    switch textAlignment {
    case .center: return 0.5
    case .right: return 1
    case .left, .justified, .natural: return 0
    @unknown default: return 0
    }
  }

  private func getStringIndex(point: CGPoint) -> Int? {
    guard let textData,
          let lines = CTFrameGetLines(textData.textFrame) as? [CTLine] else { return nil }

    var index: Int? = nil
    var lineOrigins = Array(repeating: CGPoint.zero, count: lines.count)
    CTFrameGetLineOrigins(textData.textFrame, CFRangeMake(0, numberOfLines), &lineOrigins)
    let textRect = textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    var relativePoint = CGPoint(x: point.x - textRect.origin.x, y: point.y - textRect.origin.y)
    relativePoint = CGPoint(x: relativePoint.x, y: textRect.size.height - relativePoint.y)

    for i in 0...lines.count {
      var lineOrigin = lineOrigins[i]
      let line = lines[i]
      var ascent: CGFloat = 0.0
      var descent: CGFloat = 0.0

      let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, nil))
      let yMin = floor(lineOrigin.y - descent)
      let yMax = ceil(lineOrigin.y + ascent)

      let penOffset = CGFloat(CTLineGetPenOffsetForFlush(line, flushFactor, textData.textSize.width))
      lineOrigin.x = penOffset

      guard relativePoint.y <= yMax else {
          break
      }

      guard relativePoint.y >= yMin,
            relativePoint.x >= lineOrigin.x && relativePoint.x <= lineOrigin.x + width else {
        continue
      }

      let position = CGPoint(x: relativePoint.x - lineOrigin.x, y: relativePoint.y - lineOrigin.y)
      index = CTLineGetStringIndexForPosition(line, position)
      break
    }

    return index
  }
}
