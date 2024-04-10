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

  public override func drawText(in rect: CGRect) {
    if let attributedText, let textData = TextUtility.shared.getTextData(attrString: attributedText, width: bounds.width, completion: nil) {
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
    if let attributedText {
      let textData = TextUtility.shared.getTextData(attrString: attributedText, width: bounds.width) { textData in
        self.attributedText = nil
        self.attributedText = textData.attrString
        self.delegate?.asynUILabel(didUpdateLabelWith: self)
      }
      if let textData {
        self.textData = textData
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: textData.textSize.width, height: textData.textSize.height)
      } else {
        return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
      }
    } else {
      return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    }
  }
}
