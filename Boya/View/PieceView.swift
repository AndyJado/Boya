//
//  PieceView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/27.
//

import SwiftUI

struct PieceView: View {
    
    @State private var words: [Aword] = [Aword(text: "sasaa", secondSpent: 2, edition: 1),Aword(text: "sasa", secondSpent: 9, edition: 2)]
    @State private var texteddy: String = "warp it up"
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<words.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(words[i].text)
                            .underline()
                        TextEditor(text: $texteddy)
                            .padding()
                            .background(.ultraThinMaterial,in: RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView()
    }
}
