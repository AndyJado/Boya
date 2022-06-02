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
    @State private var dataDict: [String:Int] = ["a":2 , "b":3]
    @State private var optDataArray: [String]?
    
    @State private var pickerIndex: Int = 0
    @State private var sliding: Double = 0
    
    func selecetedArray() -> [String] {
        if let array = optDataArray {
            return array
        } else {
            return dataArray
        }
    }
    
    func dictPlay() {
        
    }
    
    var body: some View {
        
        VStack{
            
            ScrollView {
                LazyVStack {
                    ForEach(0..<selecetedArray().count, id: \.self) { i in
                        Text(selecetedArray()[i])
                    }
                }
            }
            .frame(height: sizeManager.UIsize.height / 2)
            
            AwordView(aword: Aword(text: "a", secondSpent: Int(100*sliding), edition: 2))
                .frame(width: 200, height: 100)
            
            Slider(value: $sliding)
            
            
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
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
