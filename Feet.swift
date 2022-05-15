//
//  Feet.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/9.
//

import SwiftUI


struct FootView: View {
    var body: some View {
        
        VStack {
            Jio()
                .frame(width: 50, height: 50)
            Circle()
                .frame(width: 50, height: 50)
        }
    }
}

struct Feet: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Foot()
                    .padding()
                Foot()
            }
            .offset(x: 0, y: 300)
            .rotationEffect(Angle(degrees: -30))
        }
    }
}

struct Foot: View {
    var body: some View {
        ZStack {
            
            Jio()
                .foregroundColor(.green)
                .position(x: 15 + 3, y: -300 + 3)
                .frame(width: 60, height: 60)
                .opacity(0.5)
                
            Line()
                .stroke(.green, lineWidth: 5)
                .position(x: 0, y: 0)
                .frame(width: 30, height: 300)
                .opacity(0.4)
        }
        .shadow(color: .black, radius: 5,x: 5,y: 5)
    }
}


struct Line: Shape {
    
    
    
//    var animatableData: CGFloat {
//        get { ratio }
//        set { ratio = newValue }
//    }


    func path(in rect: CGRect) -> Path {
        Path { path in
            let midTop = CGPoint(x: rect.midX, y: rect.minY)
            let midBot = CGPoint(x: rect.midX, y: rect.maxY)
            path.move(to: midBot)
            path.addLine(to: midTop)
        }
    }

}

struct Jio: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let midPoint = CGPoint(x: rect.midX, y: rect.midY)
            path.move(to: midPoint)

            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 90 + 190),
                clockwise: false)
        }
    }
    
}


struct Feet_Previews: PreviewProvider {
    static var previews: some View {
//        FootView()
        Feet()
    }
}
