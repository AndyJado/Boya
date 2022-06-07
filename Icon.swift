//
//  Icon.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/7.
//

import SwiftUI

struct Icon: View {
    var body: some View {
        
        TypeIn(theWord: .constant(Aword(text: "", secondSpent: 1, edition: 1)), ydragged2: .constant(true), ydragged1: .constant(true), xdragged: .constant(false), focuing: false, yxAction: {}, y0Action: {})
            .offset(y:-100)
            .frame(width: 300, height: 300)
            .background() {
                AwordView(aword: Aword(text: "“sas”", secondSpent: 13000, edition: 4000000))
            }
        
        
        
        
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon()
    }
}
