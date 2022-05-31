//
//  TypeIn.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/18.
//

import SwiftUI

struct TypeIn: View {
    
    @Binding var theWord: Aword
    @Binding var dragged2:Bool
    @Binding var dragged1: Bool
    
    var focuing: Bool
    
    @State private var typerTitle: String = "↑ ↓ ← →"
    @State private var onDragging: Bool  = false
    @State private var offSize: CGSize = CGSize(width: 0, height: 0)
    
    @Environment(\.scenePhase) private var scenePhase
    //    let typerTitle:String = draggedUp ? "↑ ↓ ← → " : "↑"
    
    let timer = Timer
        .publish(every: 1, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        
        let drag = DragGesture()
            .onChanged { val in
                withAnimation {
                    onDragging = true
                    offSize.height = val.translation.height
                }
            }
            .onEnded { val in
                let h = val.translation.height
                withAnimation {
                    onDragging = false
                    switch dragged1 {
                            //1次拉起
                        case true:
                            if h > 80 {
                                dragged1 = false
                            } else if h < -100 {
                                dragged2 = true
                            }
                            //0次拉起
                        case false:
                            if h < -150 {
                                dragged1 = true
                            }
                    }
                    offSize.height = 0
                }
            }
        VStack(alignment: .center, spacing: 0) {
            
            Spacer()
            
            TextField(typerTitle,text: $theWord.text)
            // PPT
                .textInputAutocapitalization(.never)
                .foregroundColor(.primary)
                .padding(5)
                .font(.headline)
                .background(.gray)
                .cornerRadius(5)
                .brightness(0.3)
                .padding(10)
                .padding(.horizontal,20)
                .shadow(color: .primary, radius: 2)
                .frame(height: 50)
                .clipped()
                .submitLabel(.next)
            // BeHavior
                .onReceive(timer, perform: { _ in
                    if !dragged1 {
                        theWord.secondSpent += 1
                    }
                })
            // Gestures and all
                .scaleEffect( onDragging ? 1.16 : 1)
                .disabled(dragged1)
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
        TypeIn(theWord: .constant(Aword(text: "", secondSpent: 1, edition: 1)), dragged2: .constant(true), dragged1: .constant(true), focuing: false)
    }
}
