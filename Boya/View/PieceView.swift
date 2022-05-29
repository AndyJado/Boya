//
//  PieceView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/27.
//

import SwiftUI

struct PieceView: View {
    
    var picking:Int
    
    @EnvironmentObject var viewModel: EditViewModel
//    @State private var words: [Aword] = [Aword(text: "sasaa", secondSpent: 2, edition: 1),Aword(text: "sasa", secondSpent: 9, edition: 2)]
    @State private var textEdit: String = "吾与徐公孰美?"
    
    var body: some View {
        let words = viewModel.chosenthread(pickerAt: picking)
            List {
                ForEach(0..<words.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(words[i].text)
                            .underline()
                        TextEditor(text: $textEdit)
                            .background(.ultraThinMaterial,in: RoundedRectangle(cornerRadius: 5))
                    }
                    .padding()
                }
            }
            .listStyle(.plain)
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(picking: 0)
            .environmentObject(EditViewModel())
    }
}
