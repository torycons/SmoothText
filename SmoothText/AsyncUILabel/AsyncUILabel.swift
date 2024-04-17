//
//  AsyncUILabel.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import UIKit
import CoreText

public class AsyncUILabel: UILabel {
  weak var delegate: AsyncUILabelDelegate?
  private(set) var textData: TextData?

  var textUtility: TextUtility?

  var customTrailing: CustomTrailling? = nil {
    didSet {
      delegate?.asynUILabel(didUpdateLabelWith: self)
    }
  }

  public override func drawText(in rect: CGRect) {
    if let textData {
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.textMatrix = .identity
      context.translateBy(x: 0, y: textData.textSize.height)
      context.scaleBy(x: 1.0, y: -1.0)
      CTFrameDraw(textData.textFrame, context)
    } else {
      super.drawText(in: rect)
    }
  }

  public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    if let attributedText, let textUtility {
      let textData = textUtility.getTextData(
        attrString: attributedText,
        numberOfLines: numberOfLines,
        customTrailing: customTrailing,
        width: bounds.width)
      self.textData = textData
      return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: textData.textSize.width, height: textData.textSize.height)
    } else {
      return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    }
  }
}
