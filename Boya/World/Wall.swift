//
//  Wall.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/12.
//

import SwiftUI

struct Wall: View {
    
    @State var Items: [String] = ["hi",]
    
    var body: some View {
        
        NavigationView {
            ZStack{
                
                StealWallView()
            }
            .navigationTitle("current wall")
        }
        
        
        
    }
}

extension Wall {
    
    var GroundView: some View {
        Color.black
            .edgesIgnoringSafeArea([.all])
    }
    
    var ItemsView: some View {
        Text("\(Items.description)")
    }
    
}


struct Wall_Previews: PreviewProvider {
    static var previews: some View {
        Wall()
    }
}
