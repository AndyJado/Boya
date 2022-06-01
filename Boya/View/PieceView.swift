//
//  PieceView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/27.
//

import SwiftUI

struct PieceView: View {
    
    @EnvironmentObject var viewModel: EditViewModel
    
    @Binding var picking:Int
    
    
    var body: some View {
        
        var words = viewModel.chosenthread(pickerAt: picking)
        
        List {
            ForEach(0..<words.count, id: \.self) { i in
                
                let word = words[i]
                VStack(alignment: .leading, spacing: 0) {
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
                .listRowSeparator(.hidden)

            }
            .onDelete { indexSet in
                words.remove(atOffsets: indexSet)
            }
        }
        .listStyle(.plain)

    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(picking: .constant(0))
            .environmentObject(EditViewModel())
    }
}
