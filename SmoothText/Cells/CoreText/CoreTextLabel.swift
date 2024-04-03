//
//  CoreTextLabel.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 21/3/2567 BE.
//

import Foundation
import UIKit

protocol CoreTextLabelDelegate: AnyObject {
  func updateTableView()
}

final class CoreTextLabel: UITableViewCell {
  
  @IBOutlet weak var ctView: CTView!
  @IBOutlet weak var ctWidth: NSLayoutConstraint!
  @IBOutlet weak var ctHeight: NSLayoutConstraint!

  weak var delegate: CoreTextLabelDelegate?
  
  func configure(data: TextData) {
    ctView.delegate = self
    ctView.configure(textData: data)
  }
}

extension CoreTextLabel: CTViewDelegate {
  func updateView(size: CGSize) {
    ctWidth.constant = size.width
    ctHeight.constant = size.height
    layoutIfNeeded()
  }
}
