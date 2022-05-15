//
//  WindowDetail.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/13.
//

import SwiftUI

struct WindowDetail: View {
    
    private let UIsize:CGSize = UIScreen.main.bounds.size
    
    @State private var attentionRatio: CGFloat = 0.7
    @State var cornerRadius:CGFloat = 90
    @State var radius:CGFloat = 40
    @State var angleX: Angle = Angle(degrees: 0)
    
    @State private var scaling: Bool = false
    @State private var naving: Bool = false
    
    var body: some View {
        //        windowThumbnail
        
        ZStack{
            windowView
        }
        
    }
    
    
    
}

extension WindowDetail {
    var windowView: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            framedGlass(color: .cyan, size: CGSize(width: UIsize.width, height: UIsize.height / 5))
            
            HStack(alignment: .top, spacing: 0) {
                framedGlass(color: .white, size: CGSize(width: UIsize.width * attentionRatio, height: UIsize.height / 2))
                framedGlass(color: .gray,
                            size: CGSize(width: UIsize.width * (1 - attentionRatio),
                                         height: UIsize.height / 2))
            }
            
        }
    }
    
    func framedGlass(color:Color, size: CGSize, at alignment: Alignment = .bottomTrailing) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: size.width, height: size.height,alignment: alignment)
            .border(.brown, width: 8)
    }
}

extension WindowDetail {
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
            .onLongPressGesture {
                withAnimation(.easeInOut) {
                    naving.toggle()
                }
            }
            .offset(x: 0, y: scaling ? -radius * 4 : 0)
            .rotation3DEffect(angleX, axis: (x: 1, y: 0, z: 0))
            .frame(width: radius, height: radius)
        
    }
}


struct WindowDetail_Previews: PreviewProvider {
    static var previews: some View {
        WindowDetail()
    }
}
