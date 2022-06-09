//
//  PieceView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/27.
//

import SwiftUI

struct PieceView: View {
    
    @EnvironmentObject var viewModel: EditViewModel
    @Binding var onsheet:Bool
    
    var picking:Int
    
    @AppStorage("popSec") var popSec:Int = 0
    @AppStorage("popEdition") var popEdition:Int = 0
    
    
    var body: some View {
        
//        let totalpop = [Aword(text: "Total Pops", secondSpent: popSec, edition: popEdition)]
        
//        let words = viewModel.threads[viewModel.clues[picking]] ?? totalpop
        List {
            ForEach(0..<viewModel.threads[viewModel.clues[picking]]!.count, id: \.self) { i in
                
                var word = viewModel.threads[viewModel.clues[picking]]![i]
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
                        .padding(5)
                    }
                }
                .listRowSeparator(.hidden)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button("Pull") {
                        guard let _ = viewModel.threads[viewModel.clues[picking]] else {return}
                        if viewModel.threads[viewModel.clues[picking]]!.count == 1 {
                            onsheet.toggle()
                        } else {
                            word.edition += 1
                            viewModel.wordsPool.append(word)
                            viewModel.threads[viewModel.clues[picking]]?.remove(at: i)
                        }
                    }
                    .tint(.yellow)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button("Pop") {
                        if viewModel.threads[viewModel.clues[picking]]!.count == 1 {
                            onsheet.toggle()
                        } else {
                            viewModel.threads[viewModel.clues[picking]]?.remove(at: i)
                        }
                    }
                    .tint(.red)
                }
            }
            .onMove(perform: move)
        }
        .padding(.top,50)
        //        .onChange(of: viewModel.threads[viewModel.clues[picking]], perform: { newThread in
        //            if let thread = newThread {
        //                if thread.isEmpty {
        //                    viewModel.threadRemoval(at: picking)
        //                } else {
        //                    print("thread.isnotEmpty")
        //                }
        //            } else {
        //                print(viewModel.threads.keys.description)
        //            }
        //            viewModel.saveAll()
        //        })
        .listStyle(.plain)
        
    }
    
    func move(indices: IndexSet, newOffset: Int) {
        viewModel.threads[viewModel.clues[picking]]?.move(fromOffsets: indices, toOffset: newOffset)
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(onsheet: .constant(true), picking: 0,popSec: 10,popEdition: 2)
            .environmentObject(EditViewModel())
    }
}
