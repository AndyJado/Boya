//
//  PickView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/24.
//

import SwiftUI

struct Piece: Codable {
    var apiece: [Aword]
}

class PickViewModel: ObservableObject {
    
}

struct PickView: View {
    
    @State private var picking: Int = 0
    @State private var pops: [Aword] = Array(repeating: Aword(text: "sasaa", secondSpent: 2, edition: 1), count: 20)
    @State private var text = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            /*
             //            HStack {
             //                VStack {
             //                    TypeIn(textInField: $text)
             //                    Spacer()
             //                }
             //                Picker("", selection: $picking) {
             //                    ForEach(0..<pops.count, id: \.self) { i in
             //                        Text(pops[i].text)
             //                            .lineLimit(1)
             //                            .minimumScaleFactor(0.1)
             //                    }
             //                }
             //                .frame(width: 100)
             //                .clipped()
             //                .pickerStyle(.inline)
             //            }
             //            .frame( height: 200)
             //            .background(.yellow,in: RoundedRectangle(cornerRadius: 20))
             */
            TypeIn(textInField: $text)
            Picker("", selection: $picking) {
                ForEach(0..<pops.count, id: \.self) { i in
                    Text(pops[i].text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
            .pickerStyle(.inline)
            .frame(height: 100)
            .scaleEffect(0.5)
            
            
        }
    }
}

struct PickView_Previews: PreviewProvider {
    static var previews: some View {
        PickView()
    }
}
