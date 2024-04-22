//
//  AsyncUILabel+Links.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import UIKit

protocol TextDataDetectorService {
  func detect(attributedText: NSAttributedString) -> NSAttributedString
}

extension AsyncUILabel {
  struct TextDataDetectorServiceImp: TextDataDetectorService {
    let detectors: [LabelTextDetector]

    init(detectors: [LabelTextDetector]) {
      self.detectors = detectors
    }

    func detect(attributedText: NSAttributedString) -> NSAttributedString {
      var result: LabelTextDetectorData = .init(attributedText: attributedText, urlRanges: [])
      self.detectors.forEach { labelDetector in
        result = labelDetector.detect(data: result)
      }
      return result.attributedText
    }
  }
}

