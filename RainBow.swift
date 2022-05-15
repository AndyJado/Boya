//
//  RainBow.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/9.
//

import SwiftUI

struct RainBow: View {
    
    @State private var radius:CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            
            
            ZStack {
                Button("radius change") {
                    radius += 10
                }
                .blur(radius: 2)
                
                VStack {
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .butt, lineJoin: .miter, miterLimit: 3, dash: [3]))
                            .opacity(0.05)
                            .frame(width: width, height: width)
                            .offset(x: 0, y: width / 2)
                            .overlay(alignment: .bottom) {
                                Drag(radiusTrace: width / 2)
                            }
                        
                        
                    }
                }
                .ignoresSafeArea()
            }
        }
        
    }
}

struct Arc: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let midPoint = CGPoint(x: rect.minX, y: rect.maxY)
            path.move(to: midPoint)
            
            path.addArc(
                center: CGPoint(x: rect.maxX, y: rect.maxY),
                radius: rect.height,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees:  270),
                clockwise: false)
        }
    }
    
}


struct RainBow_Previews: PreviewProvider {
    static var previews: some View {
        RainBow()
    }
}
