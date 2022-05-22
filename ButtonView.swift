//
//  ButtonView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/11.
//

import SwiftUI




struct ButtonView: View {
    
    @State private var pressedBtn: Bool = false
    
    @State private var data:Set<String> = Set(["1","2","3"])
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        VStack{
            Button {
                pressedBtn.toggle()
                data.removeFirst()
            } label: {
                Text(Array(data)[0])
                    .padding(20)
                    .background(.orange)
            }
            
            pressedBtn ? Text("\(data.description)") : nil
            
            Wave()
//                .stroke()
                .frame(width: 200, height: 200)
                
            
            
        }

//        .sheet(isPresented: $pressedBtn,
//               onDismiss: nil) {
//            Text("helo")
//                .frame(width: 50, height: 50)
//        }
               
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
