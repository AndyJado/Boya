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
    @Binding var xdragged: Bool
    
    var focuing: Bool
    
    var yxAction: (() -> Void)
    
    @State private var typerTitle: String = "↑ ↓ ← →"
    @State private var onDragging: Bool  = false
    
    @State private var offSize: CGSize = CGSize(width: 0, height: 0)
    
//    #warning("TODO:")
//    @GestureState private var offSize: CGSize = .zero
    
    @Environment(\.scenePhase) private var scenePhase
    //    let typerTitle:String = draggedUp ? "↑ ↓ ← → " : "↑"
    

    
    var body: some View {
        
        let timer = Timer
            .publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                !focuing
            }
        
        let drag = DragGesture()
            .onChanged { val in
                withAnimation {
                    onDragging = true
                    offSize.height = val.translation.height
                    offSize.width = val.translation.width / 1.2
                }
            }
            .onEnded { val in
                let h = val.translation.height
                let w = val.translation.width
                withAnimation {
                    onDragging = false
                    
                    switch ydragged1 {
                            //1次拉起
                        case true:
                            
                            if w < -200 {
                                yxAction()
                            }
                            
                            if h > 80 {
                                ydragged1 = false
                            } else if h < -80 {
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
            TextField(typerTitle,text: $theWord.text)
            // PPT
                .foregroundColor(.primary)
                .padding(5)
                .font(.headline)
                .background( .gray)
                .cornerRadius(5)
                .brightness(0.3)
                .padding(10)
                .padding(.horizontal,20)
                .shadow(color:onDragging ? .orange : .primary, radius: 3)
                .frame(height: 50)
                .clipped()
                .submitLabel(.next)
            // BeHavior
                .onReceive(timer, perform: { _ in
                    if !ydragged1 {
                        theWord.secondSpent += 1
                    }
                })
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
        TypeIn(theWord: .constant(Aword(text: "", secondSpent: 1, edition: 1)), ydragged2: .constant(true), ydragged1: .constant(true), xdragged: .constant(false), focuing: false, yxAction: {})
    }
}
