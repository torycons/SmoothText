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
    guard let attributedText else { return nil }
    let textRect = textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
    let path = CGMutablePath()
    path.addRect(textRect)
    let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: attributedText.length), path, nil)
    
    guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return nil }

    var index: Int? = nil
    var lineOrigins = Array(repeating: CGPoint.zero, count: lines.count)
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), &lineOrigins)

    let relativePoint = CGPoint(x: point.x, y: textRect.size.height - point.y)

    for i in 0..<lines.count {
      var lineOrigin = lineOrigins[i]
      let line = lines[i]
      var ascent: CGFloat = 0.0
      var descent: CGFloat = 0.0

      let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, nil))
      let yMin = floor(lineOrigin.y - descent)
      let yMax = ceil(lineOrigin.y + ascent)

      let penOffset = CGFloat(CTLineGetPenOffsetForFlush(line, flushFactor, textRect.width))
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
