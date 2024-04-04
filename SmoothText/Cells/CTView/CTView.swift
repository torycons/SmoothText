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
  private var currentBounds: CGRect = .zero
  private var shouldUpdateText: Bool = false

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
    let textData = TextUtility.shared.getTextData(attrString: textData.attrString, width: bounds.width)
    shouldUpdateText = textData != self.textData || currentBounds != bounds
    self.textData = textData
  }

  func updateText() {
    guard let textData else { return }
    UIView.performWithoutAnimation {
      self.invalidateIntrinsicContentSize()
      self.delegate?.updateView(size: textData.size)
      self.setNeedsDisplay()
    }
  }

  override func layoutSubviews() {
    if let textData, shouldUpdateText {
      currentBounds = bounds
      configure(textData: textData)
      updateText()
      shouldUpdateText = false
    }
    super.layoutSubviews()
  }

  override var intrinsicContentSize: CGSize {
    return textData?.size ?? .zero
  }
}
