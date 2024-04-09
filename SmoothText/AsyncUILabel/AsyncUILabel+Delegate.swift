//
//  AsyncUILabel+Delegates.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation

public protocol AsyncUILabelDelegate: AnyObject {
  func asynUILabel(didUpdateLabelWith label: AsyncUILabel)
}
