//
//  AsyncUILabel+Delegates.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 9/4/2567 BE.
//

import Foundation

public protocol AsyncUILabelDelegate: AnyObject {
  func asynUILabel(didUpdateLabelWith label: AsyncUILabel)
  func asynUILabel(didTapLabelWith label: AsyncUILabel)
  func asynUILabel(_ label: AsyncUILabel, didTapLinkWith url: URL)
}
