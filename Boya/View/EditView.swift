//
//  EditView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/17.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel:EditViewModel = EditViewModel()
    
    @State private var picking:Int = 0
    
    @State private var showAlert:Bool = false
    
    @State private var pickerOn:Bool = false
    @State private var threadOn:Bool = false
    
    @State private var clueUpdate: Bool = false
    
    @State private var bubblesOn:Bool = false
    
    @FocusState private var focuing: Bool
    
    @State private var typerOffset: CGFloat = .zero
    
    @AppStorage("popSec") var popSec: Int = 0
    @AppStorage("popEdition") var popEdition: Int = 0
    
    var body: some View {
        
        let clue = viewModel.clues[picking]
        
        let lastPicking = viewModel.clues.endIndex - 1
        
        let contentFocus:Bool = focuing || pickerOn
        
        let tap2Action = {
            // Focus: IF remove do block, <Void,Never>.
            do {
                Task {
                    await viewModel.timeAcotr.clearHand()
                    await viewModel.timeAcotr.onFocus()
                    focuing.toggle()
                }
            }
        }
        
        let pressAction = {
            viewModel.pressedAct(pickerAt: picking)
            if picking == lastPicking { picking = 1 }
        }
        
        let cacheThread = {
            viewModel.cacheThread(at: picking)
            picking = 1
        }
        
        let pushPool = {
            switch clue {
            case "Pop":
                if viewModel.wordsPool.isEmpty {
                    picking = lastPicking
                } else {
                    showAlert.toggle()
                }
            case "...":
                viewModel.Pool2Thread(clue: clue)
                withAnimation {
                    picking = 1
                }
                
            default:
                viewModel.Pool2Thread(clue: clue)
            }
        }
        
        let dropPool = {
            viewModel.thread2Pool(&picking)
        }
        
        ZStack {
            // 双击退回编辑 (没有保存动作)
            // 长按进入pop (pop保存)
            WordPoolView(items: $viewModel.wordsPool, currentItem: $viewModel.aword, currentPop: $viewModel.popword, tap2Action: tap2Action , pressAction: pressAction, pinchAction: {})
                .opacity(contentFocus ? 0.35 : 1)
                .blur(radius: contentFocus ? 1.6 : 0)
                .disabled(contentFocus)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        guard !pickerOn else {return pickerOn.toggle()}
                        switch focuing {
                        case false:
                            Task{ await viewModel.timeAcotr.onFocus()
                                focuing.toggle()
                            }
                        case true:
                            Task { await viewModel.timeAcotr.endFocus()
                                focuing.toggle()
                            }
                        }
                    }
                }
            
            
            VStack(alignment: .center, spacing: 0) {
                
                TypeIn(theWord: $viewModel.aword, dragUp2: $threadOn, dragUp1: $pickerOn, dragLeft: $bubblesOn, focuing: $focuing.wrappedValue, pushThread: cacheThread, pushPool: pushPool, dropThread: dropPool)
                    .focused($focuing)
                    .offset(y: typerOffset)
                    .onChange(of: focuing) { focuing in
                        if focuing {
                            typerOffset = -340
                        } else {
                            typerOffset = 0
                        }
                    }
                    .onSubmit {
                        viewModel.submitted()
                    }
                    .zIndex(1)
                    .animation(Animation.interpolatingSpring(stiffness: 100, damping: 15), value: typerOffset)
                
                if pickerOn {
                    PickView(clues: $viewModel.clues, picking: $picking)
                        .disabled(focuing)
                    
                } else if !focuing {
                    
                    Text(clue)
                        .scaleEffect(clueUpdate ? 1.3 : 1)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .padding(.horizontal, 40)
                        .frame( height: 20, alignment: .center)
                        .animation(Animation.interactiveSpring().speed(0.3), value: clueUpdate)
                        .onChange(of: viewModel.popword) { word in
                            clueUpdate.toggle()
                            popSec += word?.secondSpent ?? 0
                            popEdition += word?.edition ?? 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.popword = nil
                            }
                        }
                        .padding(.bottom,30)
                } else {
                    EmptyView()
                }
            }
            .ignoresSafeArea()
        }//Zstack
        .alert("Pop", isPresented: $showAlert) {
            HStack {
                Button {
                    withAnimation {
                        viewModel.Pool2Thread(clue: clue)
                    }
                } label: {
                    Text("pop")
                        .foregroundColor(.red)
                }
                Button("bob") {
                    picking = viewModel.clues.count - 1
                }
                
            }
        }
        .sheet(isPresented: $threadOn) {
            switch clue {
            case "...":
                BubblesView() {
                    // when pull a bubble
                    picking += 1
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            case "Pop":
                AwordView(aword: Aword(text: "", secondSpent: popSec, edition: popEdition))
                    .scaledToFill()
                    .ignoresSafeArea()
                    .presentationDetents([.height(200)])
                    .presentationDragIndicator(.visible)
            default:
                ThreadView(sheetOn: $threadOn, key: clue) {
                    viewModel.clues.remove(at: picking)
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                
            }
        }
        .environmentObject(viewModel)
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                viewModel.saveAll()
            }
        }
    }
    
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
