//
//  TextUtility.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 29/3/2567 BE.
//

import Foundation
import CoreText
import UIKit

private let textDataQueue = DispatchQueue(label: "com.smoothText.textData")

final class TextUtility {
  private let cache: TextCache

  static let shared: TextUtility = TextUtility()

  private init(cache: TextCache = TextCacheImp()) {
    self.cache = cache
  }

  func calculateFrameSize(attrString: NSAttributedString, width: CGFloat) -> CGSize {
    let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
    let cfRange = CFRangeMake(0, attrString.string.utf16.count)
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, cfRange, nil, size, nil)
  }

  func getTextData(attrString: NSAttributedString, width: CGFloat) -> TextData {
    if let data = cache.get(key: attrString, width: width) {
        return data
    } else {
        let size = calculateFrameSize(attrString: attrString, width: width)
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: size))
        let ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        let textData = TextData(attrString: attrString, width: width, frame: ctFrame, size: size)
        cache.update(key: attrString, width: width, textData: textData)
        return textData
    }
  }
}

protocol TextCache {
  func update(key: NSAttributedString, width: CGFloat, textData: TextData)
  func get(key: NSAttributedString, width: CGFloat) -> TextData?
  func clearAllCacheData()
}

struct TextData: Equatable {
  let attrString: NSAttributedString
  let width: CGFloat
  let frame: CTFrame
  let size: CGSize
}

final class TextCacheImp: TextCache {
  class CacheData {
    var sizes: [CGFloat: TextData] = [:]
  }

  private let cache: NSCache<NSAttributedString, CacheData> = NSCache()

  func update(key: NSAttributedString, width: CGFloat, textData: TextData) {
    if let data = cache.object(forKey: key) {
      data.sizes[width] = textData
    } else {
      let newCacheData = CacheData()
      newCacheData.sizes[width] = textData
      cache.setObject(newCacheData, forKey: key)
    }
  }

  func get(key: NSAttributedString, width: CGFloat) -> TextData? {
    if let data = cache.object(forKey: key) {
      return data.sizes[width]
    }
    return nil
  }

  func clearAllCacheData() {
    cache.removeAllObjects()
  }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
