//
//  Drag.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/9.
//

import SwiftUI

struct Drag: View {
    
    var radiusTrace:CGFloat = 200
    let rad:CGFloat = 60
    
    @State private var dragVal1:CGFloat = 0
    @State private var dragVal2:CGFloat = 0
    @State private var holdingPos:Bool = false
    
    var body: some View {
        VStack {
            
            Text("""
                "1:\(dragVal1) and 2: \(dragVal2)
                holdingPos: \(holdingPos.description)
                """)
            
            Spacer()
            
            ZStack {
                
                leftFoot
                    .offset(x: 0, y: -radiusTrace + rad / 2)
                    .rotationEffect(Angle(degrees: dragVal1 / 3),anchor: .bottom)
                    .gesture(
                        DragGesture()
                            .onChanged { val in
                                withAnimation {
                                dragVal1 = val.translation.width
                                }
                            }
                            .onEnded { val in
                                
                                if !holdingPos {
                                    withAnimation {
                                        dragVal1 = 0
                                    }
                                }
                                
                            }
                    )
                    .gesture(
                        LongPressGesture()
                            .onEnded { _ in
                                holdingPos.toggle()
                            }
                    )
                    .onChange(of: holdingPos) { _ in
                        withAnimation {
                            dragVal1 = 0
                        }
                    }
                
                rightFoot
                    .offset(x: 0, y: -radiusTrace + rad / 2)
                    .rotationEffect(Angle(degrees: dragVal2 / 3),anchor: .bottom)
                    .gesture(
                        DragGesture()
                            .onChanged { val in
                                withAnimation {
                                dragVal2 = val.translation.width
                                }
                            }
                            .onEnded { val in
                                
                                if !holdingPos {
                                    withAnimation {
                                        dragVal2 = 0
                                    }
                                }
                                
                            }
                    )
                    .gesture(
                        LongPressGesture()
                            .onEnded { _ in
                                holdingPos.toggle()
                            }
                    )
                    .onChange(of: holdingPos) { _ in
                        withAnimation {
                            dragVal2 = 0
                        }
                    }
            }
            
            
        }
    }
}

// Gesture effect
extension Drag {
    
}

// Foot View
extension Drag {
    
    private var  leftFoot: some View {
        Circle()
        //now shape
            .trim(from: 0, to: 0.5)
            .rotation(Angle(degrees: 90))
        //View Now
            .frame(width: rad, height: rad)
            .foregroundColor(.green)
            .shadow(color: .orange, radius: 9)
    }
    
    private var  rightFoot: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .rotation(Angle(degrees: -90))
            .foregroundColor(.orange)
            .shadow(color: .green, radius: 9)
//                    .position(x: rad / 2, y: 0)
            .frame(width: rad, height: rad)
    }
    
}


struct Drag_Previews: PreviewProvider {
    static var previews: some View {
        Drag()
    }
}
