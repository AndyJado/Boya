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
    
    var body: some View {
        let words = viewModel.chosenthread(pickerAt: picking)
        List {
            ForEach(0..<words.count, id: \.self) { i in
                VStack(alignment: .leading, spacing: 0) {
                    let word = words[i]
                    ZStack {
                        AwordView(aword: word)
                        HStack(alignment: .top) {
                            Text(word.text)
                            Spacer()
                            VStack {
                                Spacer()
                                Text("total sec:" + word.secondSpent.description)
                                    .underline()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                Text("edition:" + word.edition.description)
                                    .underline()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                            .opacity(0.4)
                            .frame(width: 30, height: 20, alignment: .trailing)
                            
                        }
                        .padding()
                    }
                }
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
