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
    
    @StateObject private var viewModel:EditViewModel = EditViewModel()
    
    @State private var picking:Int = 0
    
    @State private var pickerOn:Bool = false
    @State private var threadOn:Bool = false
    
    @State private var clueUpdate: Bool = false
    
    @State private var bubblesOn:Bool = false
    
    @FocusState private var focuing: Bool
    
    @AppStorage("popSec") var popSec: Int = 0
    @AppStorage("popEdition") var popEdition: Int = 0
    
    var body: some View {
        
        let key = viewModel.clues[picking]
        
        let contentFocus:Bool = focuing || pickerOn
        
        let tap2Action = {focuing.toggle()}
        
        let lastPicking = viewModel.clues.endIndex - 1
        
        let pressAction = {
            
            if picking == lastPicking {
                viewModel.pressedAct(pickerAt: picking)
                picking = 1
            } else {
                viewModel.pressedAct(pickerAt: picking)
            }
            
        }
        
        let yxAction = {
            viewModel.cacheThread(at: picking)
            picking = 1
        }
        
        let y0Action = {
            viewModel.Pool2Thread()
        }
        
        let pinchAction = {
            print("pinched!")
        }
        
        ZStack {
            // 双击退回编辑 (没有保存动作)
            // 长按进入pop (pop保存)
            WordPoolView(items: $viewModel.wordsPool, currentItem: $viewModel.aword, currentPop: $viewModel.popword, tap2Action: tap2Action , pressAction: pressAction, pinchAction: pinchAction)
                .opacity(contentFocus ? 0.35 : 1)
                .blur(radius: contentFocus ? 1.6 : 0)
                .disabled(contentFocus)
            
            VStack(alignment: .center, spacing: 0) {
                TypeIn(theWord: $viewModel.aword, ydragged2: $threadOn, ydragged1: $pickerOn, xdragged: $bubblesOn, focuing: $focuing.wrappedValue, yxAction: yxAction, y0Action: y0Action)
                    .focused($focuing)
                    .onSubmit {
                        viewModel.submitted()
                        focuing = true
                    }
                    .zIndex(1)
                
                if pickerOn {
                    PickView(clues: $viewModel.clues, picking: $picking)
                        .disabled(focuing)
                    
                } else if !focuing {
                    
                    Text(key)
                        .scaleEffect(clueUpdate ? 1.3 : 1)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .padding(.horizontal, 40)
                        .frame( height: 20, alignment: .center)
                        .animation(Animation.interactiveSpring().speed(0.2), value: clueUpdate)
                        .onChange(of: viewModel.popword) { word in
                            
                            clueUpdate.toggle()
                            popSec += word?.secondSpent ?? 0
                            popEdition += word?.edition ?? 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                viewModel.popword = nil
                            }
                            
                            
                        }
                } else {
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: $threadOn, content: {
            switch key {
            case "...":
                BubblesView() {
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
                ThreadView(key: key) {
                    viewModel.clues.remove(at: picking)
                    threadOn = false
                }
            }
        })
        .environmentObject(viewModel)
        .onTapGesture {
            withAnimation {
                if contentFocus {
                    focuing = false
                    pickerOn = false
                } else {
                    focuing.toggle()
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                viewModel.saveCacheThreads()
                viewModel.saveThreads()
            }
        }
    }
    
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
