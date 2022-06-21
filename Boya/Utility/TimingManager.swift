//
//  TimingManager.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/21.
//

import SwiftUI


actor TimeStampAcotr {
    
    private var startStack = [Date]()
    private var endStack = [Date]()
    
    func onFocus() {
        startStack.append(Date())
    }
    
    func endFocus() {
        endStack.append(Date())
    }
    
    func timeReduce() -> Int {
        guard !startStack.isEmpty && !endStack.isEmpty else {return 0}
        var sec:Double = 0
        for (i,j) in zip(startStack, endStack) {
            sec += j.timeIntervalSince(i)
        }
        clearStacks()
        return Int(sec)
    }
    
    func clearStacks() {
        startStack.removeAll()
        endStack.removeAll()
    }
    
}

