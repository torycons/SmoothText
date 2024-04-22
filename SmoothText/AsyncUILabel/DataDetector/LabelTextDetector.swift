//
//  LabelTextDetector.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 22/4/2567 BE.
//

import Foundation
import UIKit

protocol LabelTextDetector {
  var linkAttributed: [NSAttributedString.Key: Any] { get }
  func detect(data: LabelTextDetectorData) -> LabelTextDetectorData
}

struct LabelTextDetectorData {
  let attributedText: NSAttributedString
  let urlRanges: [NSRange]
}
