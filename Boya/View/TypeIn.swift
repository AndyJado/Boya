//
//  TypeIn.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/18.
//

import SwiftUI


enum GuideLine:String {
    
    case x0y0 = "•   ↑   ↑!   ↓   ←   ←.."
    
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
    
    @GestureState private var offSize: CGSize = .zero
    @State private var typerTitle: GuideLine = .x0y0
    
    @Environment(\.scenePhase) private var scenePhase
    
    var drag: some Gesture {
        
        DragGesture()
            .updating($offSize) { current, offSize, _ in
                    offSize = current.translation
            }
            .onChanged { val in
                let h = val.translation.height
                let w = val.translation.width
                
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
                    if w < -200 {
                        threadDroping = true
                    }
                    
                }
            }
            .onEnded { val in
                let h = val.translation.height
                let w = val.translation.width
                
                threadPoping = false
                threadDroping = false
                
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
                        
                        if h > 25 {
                            pushPool()
                        }
                        
                        // upward, threadView
                        if h < -400 {
                            dragUp2 = true
                        } else if h < -50 {
                            // upward
                            dragUp1 = true
                        } else if w < -150 {
                            dropThread()
                        }
                        
                    }
                }
            }
        
    }
    
    var body: some View {
        
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
        
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            TextField(typerTitle.rawValue,text: $theWord.text)
            // PPT
                .autocorrectionDisabled(true)
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
                .onReceive(timerPushThread) { _ in
                    pushThread()
                }
                .onReceive(timerDropThread) { _ in
                    dropThread()
                }
            
            // Gestures and all
                .disabled(dragUp1)
                .offset(offSize)
                .gesture(drag, including: focuing ? GestureMask.none : GestureMask.all)
                .onChange(of: dragUp1) { bool in
                    typerTitle = bool ? .x0y1 : .x0y0
                }
                .onChange(of: focuing) { bool in
                    typerTitle = bool ? .focusing : .x0y0
                }
        }
        .animation(Animation.interpolatingSpring(stiffness: 50, damping: 9), value: offSize)
    }
}

struct TypeIn_Previews: PreviewProvider {
    static var previews: some View {
        TypeIn(theWord: .constant(Aword(text: "", secondSpent: 1, edition: 1)), dragUp2: .constant(true), dragUp1: .constant(true), dragLeft: .constant(false), focuing: false, pushThread: {}, pushPool: {}, dropThread: {})
    }
}
