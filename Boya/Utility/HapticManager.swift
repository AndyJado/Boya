//
//  HapticManager.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/21.
//

import SwiftUI


func playSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
func playFeedbackHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    
