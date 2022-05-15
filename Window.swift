//
//  Window.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/12.
//

import SwiftUI

struct Window: View {
    
    @State var cornerRadius:CGFloat = 10
    @State var radius:CGFloat = 40
    @State var angleX: Angle = Angle(degrees: 0)
    
    @State private var scaling: Bool = false
    @State private var naving: Bool = false
    
    
    private let UIsize:CGSize = UIScreen.main.bounds.size
    
    var body: some View {
        
        ZStack {
            
            windowThumbnail
            
            
        }
        
        
        
        
    }
}




extension Window {
    
    var windowThumbnail: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .shadow(color: .gray, radius: 5)
            .overlay(content: {
                Wave()
                    .stroke(.green,lineWidth: 1)
                    .foregroundColor(Color.white)
                    .clipped()
                
            })
            .scaleEffect(scaling ? 4 : 1)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    scaling.toggle()
                }
            }
            .offset(x: 0, y: scaling ? -radius * 4 : 0)
            .rotation3DEffect(angleX, axis: (x: 1, y: 0, z: 0))
            .frame(width: radius, height: radius)
        
    }
    
}

struct Window_Previews: PreviewProvider {
    static var previews: some View {
        Window()
    }
}
