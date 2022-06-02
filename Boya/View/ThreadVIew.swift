//
//  ThreadVIew.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/2.
//

import SwiftUI

struct ThreadVIew: View {
    
    @State private var thread:[Aword] = Array(repeating: Aword(text: "不是我干的", secondSpent: 10, edition: 2), count: 100)
    
    func thread2Colors() -> [Color] {
        
        var colors:[Color] = []
        
        for i in thread {
            colors.append(contentsOf: i.Aword2Color())
        }
        
        return colors
        
    }
    
    var body: some View {
        
        Circle()
            .fill(
                RadialGradient(gradient: Gradient(colors: thread2Colors()), center: .center, startRadius: 0, endRadius: 40)
                
            )
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        
        
        
    }
}

struct ThreadVIew_Previews: PreviewProvider {
    static var previews: some View {
        ThreadVIew()
    }
}
