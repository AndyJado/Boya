//
//  ThreadVIew.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/2.
//

import SwiftUI

struct BubbleView: View {
    
    var thread:[Aword]
    
    func thread2Colors() -> [Color] {
        

        // ave aword time, total thread time
        var sumWord = Aword()
        
        for i in thread {
            sumWord.secondSpent += i.secondSpent
            sumWord.edition += max(1, i.edition)
        }
//        sumWord.edition = thread.count

        return sumWord.Aword2Color()
        
    }
    
    func threadColors() -> [Color] {
        
        var colors:[Color] = []
        for i in thread {
            colors.append(contentsOf: i.Aword2Color())
        }
        return colors
    }
    
    var body: some View {
        
            Circle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: thread2Colors()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                )
//                .overlay {
//                    Text(thread[0].text)
//                        .minimumScaleFactor(0.01)
//                }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            
        
        
        
    }
}

struct ThreadVIew_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(thread: TestThread)
    }
}
