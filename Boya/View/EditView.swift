//
//  EditView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/17.
//

import SwiftUI
import Combine

struct EditView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var viewModel:EditViewModel = EditViewModel()
    
    @State private var picking:Int = 0
    
    @State private var pickerOn:Bool = false
    @State private var threadOn:Bool = false
    
    
    @FocusState private var focuing: Bool
    
    
    var body: some View {
        
        let contentFocus:Bool = focuing || pickerOn
        
        let tap2Action = {focuing.toggle()}
        
        let pressAction = {
            
            if picking == viewModel.clues.endIndex - 1 {
                viewModel.Pressed(pickerAt: picking)
                picking = 1
            } else {
                viewModel.Pressed(pickerAt: picking)
            }
            
        }
        
        NavigationView {
            ZStack {
                // 双击退回编辑 (没有保存动作)
                // 长按进入pop (pop保存)
                LazyGridView(items: $viewModel.wordsPool, currentItem: $viewModel.aword, currentPop: $viewModel.popword, tap2Action: tap2Action , pressAction: pressAction)
                    .opacity(contentFocus ? 0.35 : 1)
                    .blur(radius: contentFocus ? 1.6 : 0)
                    .disabled(contentFocus)
                
                VStack(alignment: .center, spacing: 0) {
                    TypeIn(theWord: $viewModel.aword, dragged2: $threadOn, dragged1: $pickerOn, focuing: $focuing.wrappedValue)
                        .focused($focuing)
                        .onSubmit {
                            viewModel.submitted()
                            focuing = true
                        }
                    
                    if pickerOn {
                        PickView(clues: $viewModel.clues, picking: $picking)
                            .disabled(focuing)
                    } else if !focuing {
                        Text(viewModel.clues[picking])
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal, 40)
                            .frame( height: 20, alignment: .center)
                    } else {
                        EmptyView()
                    }
                }
                
                NavigationLink("", isActive: $threadOn) {
                    PieceView(picking: $picking)
                }
            }
            .onTapGesture {
                withAnimation {
                    focuing.toggle()
                }
            }
        }
        .navigationBarHidden(true)
        .environmentObject(viewModel)
    }
    
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
