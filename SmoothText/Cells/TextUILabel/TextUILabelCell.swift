//
//  TextUILabelCell.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 19/3/2567 BE.
//

import UIKit

final class TextUILabelCell: UITableViewCell {
  @IBOutlet weak var lbLabel: UILabel!
  @IBOutlet weak var vBubble: UIView! {
    didSet {
      vBubble.layer.cornerRadius = 16
    }
  }

  func configure(text: String) {
    lbLabel.attributedText = NSAttributedString(string: text)
  }
}
