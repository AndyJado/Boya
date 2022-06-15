//
//  ThreadView.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/9.
//

import SwiftUI

struct ThreadView: View {
    @EnvironmentObject var viewModel: EditViewModel
    
    var key: String
    var removeClue: () -> Void
    var body: some View {
        if let thread = viewModel.threads[key] {
            if thread.isEmpty {
                Button {
                    viewModel.threads.removeValue(forKey: key)
                    removeClue()
                } label: {
                    Text("Remove from threads")
                }
            } else {
                let count = thread.count
                LazyVStack(alignment: .listRowSeparatorLeading, spacing: 5, pinnedViews: .sectionHeaders){
                    ForEach(0..<count,id:\.self) { i in
                        AwordView(aword: thread[i])
                            .frame(width: 350, height: 30, alignment: .topLeading)
                            .onTapGesture(count: 2) {
                                let pop: Aword = viewModel.threads[key]!.popAt(at: i)
                                viewModel.wordsPool.append(pop)
                            }
                            .onLongPressGesture {
    //                            viewModel.threads[key]!.remove(at: i)
                            }
                    }
                }
                .onChange(of: count) { count in
                    if count == 0 {
                        viewModel.threads.removeValue(forKey: key)
                        removeClue()
                    }
                }
            }
            
        }
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView(key: "sa", removeClue: {})
            .environmentObject(EditViewModel())
    }
}
