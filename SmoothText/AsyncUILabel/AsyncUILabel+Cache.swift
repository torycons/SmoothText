//
//  AsyncUILabel+Cache.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation
import CoreText
import UIKit

protocol AsyncUILabelTextCache {
  func update(key: NSAttributedString, width: CGFloat, textData: AsyncUILabel.TextData)
  func get(key: NSAttributedString, width: CGFloat) -> AsyncUILabel.TextData?
  func clearAllCacheData()
}

extension AsyncUILabel {
  struct TextData: Equatable {
    let attrString: NSAttributedString
    let viewFullWidth: CGFloat
    let textFrame: CTFrame
    let textSize: CGSize
  }

  final class TextCache: AsyncUILabelTextCache {
    class CacheData {
      var sizes: [CGFloat: TextData] = [:]
    }

    private let queue = DispatchQueue(label: "com.asynclabel.cache")
    private let cache: NSCache<NSAttributedString, CacheData> = NSCache()

    func update(key: NSAttributedString, width: CGFloat, textData: TextData) {
      if let data = cache.object(forKey: key) {
        queue.async {
          data.sizes[width] = textData
        }
      } else {
        let newCacheData = CacheData()
        newCacheData.sizes[width] = textData
        cache.setObject(newCacheData, forKey: key)
      }
    }

    func get(key: NSAttributedString, width: CGFloat) -> TextData? {
      if let data = cache.object(forKey: key) {
        return queue.sync {
          data.sizes[width]
        }
      }
      return nil
    }

    func clearAllCacheData() {
      cache.removeAllObjects()
    }
  }
}
