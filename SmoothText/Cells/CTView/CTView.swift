//
//  CTView.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 21/3/2567 BE.
//

import Foundation
import UIKit

protocol CTViewDelegate: AnyObject {
  func updateView(size: CGSize)
}

final class CTView: ConstraintUIView {
  private var textData: TextData?
  private var preferredMaxLayoutWidth: CGFloat = 0
//  private var invalidateContentSize = false
  private var currentWidth: CGFloat = 0

  weak var delegate: CTViewDelegate?

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let textData else { return }
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.textMatrix = .identity
    context.translateBy(x: 0, y: textData.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    CTFrameDraw(textData.frame, context)
  }

  func configure(textData: TextData) {
//    let currentWidth = bounds.width
//    let textData = TextUtility.shared.getTextData(attrString: data, width: currentWidth)
//    let shouldUpdate = self.currentWidth == 0 || textData.width != currentWidth
    self.textData = textData
//    self.currentWidth = currentWidth
//    self.invalidateContentSize = shouldUpdate
    UIView.performWithoutAnimation {
      self.delegate?.updateView(size: textData.size)
      self.invalidateIntrinsicContentSize()
      self.setNeedsDisplay()
    }
  }

  override var intrinsicContentSize: CGSize {
    return textData?.size ?? .zero
  }
}
