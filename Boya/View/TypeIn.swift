//
//  TypeIn.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/18.
//

import SwiftUI

struct TypeIn: View {
    
    @Binding var theWord: Aword
    @Binding var ydragged2: Bool
    @Binding var ydragged1: Bool
    //TODO: currently unused
    @Binding var xdragged: Bool
    
    var focuing: Bool
    
    var yxAction: (() -> Void)
    var y0Action: (() -> Void)
    
    
    @State private var ydragged0: Bool = false
    
    @State private var typerTitle: String = "↑ ↑ ←"
    //    @State private var onDragging: Bool  = false
    @State private var threadPoping: Bool = false
    
    @GestureState private var onDragging: Bool = false
    
    @State private var offSize: CGSize = .zero
    
    @Environment(\.scenePhase) private var scenePhase
    
    func guideLine() -> String {
        
        switch ydragged1 {
            case true:
                return "↑ ↓ ←"
            default:
                if focuing {
                    return "Cat got your tongue?"
                } else {
                    return "↑"
                }
        }
        
    }
    
    var body: some View {
        
        
        let timer = Timer
            .publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !focuing
            }
        
        let timerPopThread = Timer
            .publish(every: 0.5, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !threadPoping
            }
        
        let timerY0Action = Timer
            .publish(every: 0.5, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !ydragged0
            }
        
        let drag = DragGesture()
            .updating($onDragging) { _, state, _ in
                state.toggle()
            }
            .onChanged { val in
                
                let h = val.translation.height
                let w = val.translation.width
                
                withAnimation {
                    //                    onDragging = true
                    offSize.height = h
                    offSize.width = w 
                }
                
                
                switch ydragged1 {
                        //1次拉起
                    case true:
                        if w < -200 {
                            threadPoping = true
                        } else if h > 30 {
                            ydragged0 = true
                        }
                        //0次拉起
                    case false:
                        
                        break
                        
                }
                
            }
            .onEnded { val in
                let h = val.translation.height
                let w = val.translation.width
                
                threadPoping = false
                ydragged0 = false
                
                withAnimation {
                    //                    onDragging = false
                    
                    switch ydragged1 {
                            //1次拉起
                        case true:
                            if w < -200 {
                                yxAction()
                            }
                            
                            if h < -80 {
                                ydragged2 = true
                            }
                            //0次拉起
                        case false:
                            
                            if w < -200 {
                                xdragged = true
                            }
                            
                            if h < -400 {
                                ydragged2 = true
                            } else if h < -150 {
                                ydragged1 = true
                            }
                            
                    }
                    offSize = .zero
                }
            }
        
        VStack(alignment: .center, spacing: 0) {
            
            Spacer()
            TextField(guideLine(),text: $theWord.text)
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
                .submitLabel(.next)
            // BeHavior
                .onReceive(timer, perform: { _ in
                    if !ydragged1 {
                        theWord.secondSpent += 1
                    }
                })
                .onReceive(timerPopThread, perform: { _ in
                        yxAction()
                })
                .onReceive(timerY0Action) { _ in
                    y0Action()
                }
                           
            // Gestures and all
                .disabled(ydragged1)
                .offset(offSize)
                .gesture(drag, including: focuing ? GestureMask.none : GestureMask.all)
            
                .onChange(of: scenePhase) { phase in
                    if phase == .active {
                        withAnimation {
                            offSize = .zero
                        }
                    }
                }
        }
    }
}

struct TypeIn_Previews: PreviewProvider {
    static var previews: some View {
        TypeIn(theWord: .constant(Aword(text: "", secondSpent: 1, edition: 1)), ydragged2: .constant(true), ydragged1: .constant(true), xdragged: .constant(false), focuing: false, yxAction: {}, y0Action: {})
    }
}
