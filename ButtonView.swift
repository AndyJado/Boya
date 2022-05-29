//
//  ButtonView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/11.
//

import SwiftUI




struct ButtonView: View {
    
    @State private var pressedBtn: Bool = false
    
    @State private var dataSet:Set<String> = Set(["1","2","3"])
    @State private var dataArray: [String] = Array(repeating: "cherryMelon歌德", count: 3)
    
    @State private var pickerIndex: Int = 0
    
    var body: some View {
        
        VStack{
            
            ScrollView {
                LazyVStack {
                    ForEach(0..<dataArray.count, id: \.self) { i in
                        Text(dataArray[i])
                    }
                }
            }
            .frame(height: sizeManager.UIsize.height / 2)
            
            
            Spacer()
            
            HStack {
                Picker("", selection: $pickerIndex) {
                    ForEach(0..<dataArray.count, id: \.self) { i in
                        Text(dataArray[i])
                            .minimumScaleFactor(0.1)
                            .onTapGesture {
                                
                                dataArray.remove(at: pickerIndex)
                            }
                    }
                }
                .pickerStyle(.inline)
                
                Spacer()
                
                VStack {
                    
                    Button {
                        var a: String
                        pressedBtn.toggle()
                        a = dataArray.popAt(at: 0)
                        print(a)
                    } label: {
                        Text(Array(dataSet)[0])
                            .padding(2)
                            .background(.orange)
                    }
 
                }
                .frame(width: 100, height: 200)
                
                
            }
            .padding()
            
            
            
        }
        .ignoresSafeArea()
        
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
