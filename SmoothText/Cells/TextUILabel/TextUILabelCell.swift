//
//  TextUILabelCell.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 19/3/2567 BE.
//

import UIKit

final class TextUILabelCell: UITableViewCell {
  @IBOutlet weak var lbLabel: UILabel!

  weak var delegate: TestUILabelAsyncDelegate?

  func configure(text: String) {
    lbLabel.attributedText = NSAttributedString(string: text)

    
  }
}

protocol TestUILabelAsyncDelegate: AnyObject {
  func update()
}

final class TestUILabel: UILabel {
  override func drawText(in rect: CGRect) {
    if let attributedText {
      let textData = TextUtility.shared.getTextData(attrString: attributedText, width: bounds.width)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.textMatrix = .identity
      context.translateBy(x: 0, y: textData.size.height)
      context.scaleBy(x: 1.0, y: -1.0)
      CTFrameDraw(textData.frame, context)
    } else {
      super.drawText(in: rect)
    }
  }

  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    if let attributedText {
      let textData = TextUtility.shared.getTextData(attrString: attributedText, width: bounds.width)
      return CGRect(x: 0, y: 0, width: textData.size.width, height: textData.size.height)
    } else {
      return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    }
  }
}


final class TestUILabelAsync: UILabel {
  weak var delegate: TestUILabelAsyncDelegate?

  override func drawText(in rect: CGRect) {
    if let attributedText {
      let textData = TextUtility.shared.getTextData(attrString: attributedText, width: bounds.width)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.textMatrix = .identity
      context.translateBy(x: 0, y: textData.size.height)
      context.scaleBy(x: 1.0, y: -1.0)
      CTFrameDraw(textData.frame, context)
    } else {
      super.drawText(in: rect)
    }
  }

  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    if let attributedText {
      let textData = TextUtility.shared.getTextData(attrString: attributedText, width: bounds.width) { textData in
        self.attributedText = nil
        self.attributedText = textData.attrString
        self.delegate?.update()
      }
      if let textData {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: textData.size.width, height: textData.size.height)
      } else {
        return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
      }
    } else {
      return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    }
  }
}
