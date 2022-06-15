//
//  TypeIn.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/18.
//

import SwiftUI


enum GuideLine:String {
    
    case x0y0 = "•   ↑   ↑!   ↓..   ←   ←.."
    
    case x0y1 = "•   ↑   ↓   ↓.."
    
    case focusing = "•   ↵"
    
}

struct TypeIn: View {
    
    @Binding var theWord: Aword
    
    @Binding var dragUp2: Bool
    @Binding var dragUp1: Bool
    //TODO: currently unused
    @Binding var dragLeft: Bool
    
    var focuing: Bool
    
    let pushThread: () -> Void
    let pushPool: () -> Void
    let dropThread: () -> Void
    
    @State private var threadDroping: Bool = false
    @State private var poolPoping: Bool = false
    @State private var threadPoping: Bool = false
    @GestureState private var onDragging: Bool = false
    
    @State private var offSize: CGSize = .zero
    @State private var typerTitle: GuideLine = .x0y0
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        
        let timerWord = Timer
            .publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !focuing
            }
        
        let timerPushThread = Timer
            .publish(every: 0.5, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !threadPoping
            }
        
        let timerDropThread = Timer
            .publish(every: 0.5, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !threadDroping
            }
        
        let timerPushPool = Timer
            .publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !poolPoping
            }
        
        let drag = DragGesture()
            .updating($onDragging) { _, state, _ in
                state.toggle()
            }
            .onChanged { val in
                let h = val.translation.height
                let w = val.translation.width
                
                withAnimation {
                    offSize.height = h
                    offSize.width = w
                }
                // Dragging
                switch dragUp1 {
                    //1次拉起
                case true:
                    // downward holding
                    if h > 50 {
                        threadPoping = true
                    }
                    //0次拉起
                case false:
                    if h > 50 {
                        // downward holding
                        poolPoping = true
                    } else if w < -200 {
                        threadDroping = true
                    }
                    
                }
                
            }
            .onEnded { val in
                let h = val.translation.height
                let w = val.translation.width
                
                threadPoping = false
                threadDroping = false
                poolPoping = false
                
                withAnimation {
                    switch dragUp1 {
                        //1次拉起
                    case true:
                        // downward , push thread
                        if h > 50 {
                            pushThread()
                        }
                        
                        // upward 80, threadview
                        if h < -50 {
                            dragUp2 = true
                        }
                        //0次拉起
                    case false:
                        // upward, threadView
                        if h < -400 {
                            dragUp2 = true
                        } else if h < -50 {
                            // upward
                            dragUp1 = true
                        } else if w < -200 {
                            dropThread()
                        }
                        
                    }
                    offSize = .zero
                }
            }
        
        VStack(alignment: .center, spacing: 0) {
            
            Spacer()
            TextField(typerTitle.rawValue,text: $theWord.text)
            // PPT
                .foregroundColor(.primary)
                .padding(5)
                .font(.headline)
                .background( .gray)
                .cornerRadius(5)
                .brightness(0.3)
                .padding(10)
                .padding(.horizontal,20)
                .shadow(color: .primary, radius: 3)
                .frame(height: 50)
                .clipped()
            // BeHavior
                .onReceive(timerWord, perform: { _ in
                    if !dragUp1 {
                        theWord.secondSpent += 1
                    }
                })
                .onReceive(timerPushThread) { _ in
                    pushThread()
                }
                .onReceive(timerPushPool) { _ in
                    pushPool()
                }
                .onReceive(timerDropThread) { _ in
                    dropThread()
                }
            
            // Gestures and all
                .disabled(dragUp1)
                .offset(offSize)
                .gesture(drag, including: focuing ? GestureMask.none : GestureMask.all)
                .onChange(of: scenePhase) { phase in
                    if phase == .active {
                        withAnimation {
                            offSize = .zero
                        }
                    }
                }
                .onChange(of: dragUp1) { bool in
                    typerTitle = bool ? .x0y1 : .x0y0
                }
                .onChange(of: focuing) { bool in
                    typerTitle = bool ? .focusing : .x0y0
                }
        }
    }
}

struct TypeIn_Previews: PreviewProvider {
    static var previews: some View {
        TypeIn(theWord: .constant(Aword(text: "", secondSpent: 1, edition: 1)), dragUp2: .constant(true), dragUp1: .constant(true), dragLeft: .constant(false), focuing: false, pushThread: {}, pushPool: {}, dropThread: {})
    }
}
