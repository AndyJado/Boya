//
//  YinYang.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/13.
//

import SwiftUI

struct YinYang: View {
    
    let UIsize = sizeManager.UIsize
    let GuaRadius = sizeManager.GuaRadius
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [.yellow,.orange]),
                                     startPoint: .bottom,
                                     endPoint: .top)
                )
                .opacity(0.6)
            
            Circle()
                .trim(from: 0, to: 0.4)
                .stroke(.green, lineWidth: 1)
                .rotationEffect(Angle(degrees: -90))
                .blur(radius: 2)
            
            
            VStack(spacing: 2) {
                yang
                yang
                yang
                yang
                    .foregroundColor(nil)
            }
            .padding(.all,8)
        }
        .frame(width: GuaRadius, height: GuaRadius)
        
    }
    
}

extension YinYang {
    
    var yin: some View {
        HStack(spacing: 2){
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .frame(maxWidth: UIsize.width / 2,maxHeight: UIsize.height / 10)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .frame(maxWidth: UIsize.width / 2,maxHeight: UIsize.height / 10)
        }
    }
    
    
    var yang: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(maxWidth: UIsize.width, maxHeight: UIsize.height / 10)
    }
    
    
    
}


struct YinYang_Previews: PreviewProvider {
    static var previews: some View {
        YinYang()
    }
}
