//
//  TestView.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/4.
//

import SwiftUI

struct TestView: View {
    
    @GestureState var magnifyBy = 1.0
    
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }
    
    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .scaleEffect(magnifyBy)
            .gesture(magnification)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
