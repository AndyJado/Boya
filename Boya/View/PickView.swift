//
//  PickView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/24.
//

import SwiftUI

struct PickView: View {
    
    @Binding var clues: [String]
    @Binding var picking: Int
    
    var body: some View {
            Picker("", selection: $picking) {
                ForEach(0..<clues.count, id: \.self) { i in
                    Text(clues[i])
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
            .pickerStyle(.inline)
            .frame(height: 200)
            .clipped()
    }
}

struct PickView_Previews: PreviewProvider {
    static var previews: some View {
        PickView(clues: .constant(["sadaskldj","ksajdk","wangli"]), picking: .constant(2))
    }
}
