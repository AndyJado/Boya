//
//  GlobalExtension.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/27.
//

import SwiftUI

extension UIPickerView {
   open override var intrinsicContentSize: CGSize {
      return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)}
}
