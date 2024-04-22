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
  func get(key: NSAttributedString, width: CGFloat, numberOfLines: Int) -> AsyncUILabel.TextData?
  func clearAllCacheData()
}

extension AsyncUILabel {
  struct TextData {
    let attrString: NSAttributedString
    let viewWidth: CGFloat
    let numberOfLines: Int
    let textFrame: CTFrame
    let textSize: CGSize
    let customTrailing: CustomTrailling?
  }

  final class TextCache: AsyncUILabelTextCache {
    class CacheData {
      var data: [TextData] = []
    }

    private let queue = DispatchQueue(label: "com.asynclabel.cache")
    private let cache: NSCache<NSAttributedString, CacheData> = NSCache()

    func update(key: NSAttributedString, width: CGFloat, textData: TextData) {
      queue.async { [weak self] in
        guard let self else { return }
        if let data = cache.object(forKey: key) {
          var newData = data.data.filter({ $0.viewWidth != width })
          newData.append(textData)
          data.data = newData
        } else {
          let newCacheData = CacheData()
          newCacheData.data = [textData]
          cache.setObject(newCacheData, forKey: key)
        }
      }
    }

    func get(key: NSAttributedString, width: CGFloat, numberOfLines: Int) -> TextData? {
      if let data = cache.object(forKey: key) {
        return queue.sync {
          data.data.first(where: { $0.viewWidth == width && $0.numberOfLines == numberOfLines })
        }
      }
      return nil
    }
    func clearAllCacheData() {
      cache.removeAllObjects()
    }
  }
}
