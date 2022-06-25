//
//  TimingManager.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/21.
//

import SwiftUI
import os.log


actor TimingManager {
    
    private var timeStack:[(Date,Date)] = []
    private var handOfTime: (left : Date?,right : Date?)
    
    
    func onFocus() {
        handOfTime.left = Date()
    }
    
    func endFocus() {
        
        handOfTime.right = Date()
        
        if let left = handOfTime.left,
           let right = handOfTime.right {
            timeStack.append((left,right))
        }
        
        handOfTime = (nil,nil)
    }
    
    func handClose() -> Int {
        
        guard !timeStack.isEmpty else {return 0}
        
        logger.debug("\(self.timeStack.debugDescription)")
        
        var sec: Double = 0
        for hand in timeStack {
            sec += hand.1.timeIntervalSince(hand.0)
        }
        clearHand()
        return Int(sec)
        
    }
    
    func clearHand() {
        timeStack.removeAll()
    }
    
}

fileprivate let logger = Logger(subsystem: "com.andyjao.Boya", category: "TimingActor")
