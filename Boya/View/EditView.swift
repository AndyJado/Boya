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
        
        let contentFocus:Bool = focuing || pickerOn
        
        let tap2Action = {focuing.toggle()}
        
        let pressAction = {
            
            if picking == viewModel.clues.endIndex - 1 {
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
        
        let pinchAction = {
            print("pinched!")
        }
        
        NavigationView {
            ZStack {
                // 双击退回编辑 (没有保存动作)
                // 长按进入pop (pop保存)
                LazyGridView(items: $viewModel.wordsPool, currentItem: $viewModel.aword, currentPop: $viewModel.popword, tap2Action: tap2Action , pressAction: pressAction, pinchAction: pinchAction)
                    .opacity(contentFocus ? 0.35 : 1)
                    .blur(radius: contentFocus ? 1.6 : 0)
                    .disabled(contentFocus)
                
                VStack(alignment: .center, spacing: 0) {
                    TypeIn(theWord: $viewModel.aword, ydragged2: $threadOn, ydragged1: $pickerOn, xdragged: $bubblesOn, focuing: $focuing.wrappedValue, yxAction: yxAction)
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
                
                NavigationLink("", isActive: $threadOn) {
                    if picking == viewModel.clues.endIndex - 1 {
                        BubblesView() {
                            picking += 1
                        }
                    } else {
                        PieceView(picking: $picking,popSec: popSec,popEdition: popEdition)
                            .toolbar {
                                EditButton()
                            }
                    }
                }
                
            }
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
        }
        .environmentObject(viewModel)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
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
