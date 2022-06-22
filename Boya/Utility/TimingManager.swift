//
//  TimingManager.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/21.
//

import SwiftUI
import os.log


actor TimingManager {
    
    private var startStack = [Date]()
    private var endStack = [Date]()
    
    func onFocus() {
        startStack.append(Date())
    }
    
    func endFocus() {
        endStack.append(Date())
    }
    
    func truncate() {
        
        let indexDiff = self.startStack.endIndex - self.endStack.endIndex
            
        guard indexDiff != 0 else {return}
        if indexDiff > 0 {
            startStack.removeLast(indexDiff)
        } else {
            logger.debug("endStack is higher!")
            endStack.removeLast(-indexDiff)
        }
        
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

fileprivate let logger = Logger(subsystem: "com.andyjao.Boya", category: "TimingActor")
