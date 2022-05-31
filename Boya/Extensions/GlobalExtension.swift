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

extension Array {
    mutating func popAt<T>(at index: Int) -> T {
        let item:T = self[index] as! T
        self.remove(at: index)
        return item
    }
}


struct StackItemModifier: ViewModifier {
    
    let Index: Int
    let count: Int
    
    func body(content: Content) -> some View {
        content
            .offset(x: 0, y: 0)
    }
}

extension View {
    
    func Yoffset(at index: Int, in count: Int) -> some View {
        modifier(StackItemModifier(Index: index, count: count))
    }
    
}
