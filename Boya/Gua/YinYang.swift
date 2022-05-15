//
//  YinYang.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/13.
//

import SwiftUI

struct YinYang: View {
    
    let UIsize:CGSize = SizeManager.sizeManager.UIsize
    let Guasize = SizeManager.sizeManager.GuaSize
    
    var body: some View {
        ZStack {
            
            Circle()
                .foregroundColor(.gray)
                .opacity(0.6)
            
            VStack(spacing: 2) {
                yang
                yin
                yang
                yin
                yang
                yin
                yin
                yin
                yin
                yang

            }
            .padding(.all,8)
        }
        .frame(width: Guasize, height: Guasize)
        
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
