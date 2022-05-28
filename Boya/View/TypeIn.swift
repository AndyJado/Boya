//
//  TypeIn.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/18.
//

import SwiftUI

struct TypeIn: View {
    

    
    @Binding var theWord: Aword
    @Binding var draggedUp: Bool
    
    @State private var offSize: CGSize = CGSize(width: 0, height: 0)
    
    var body: some View {
        
        let timer = Timer
            .publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .drop { _ in
                draggedUp
            }
        
        let drag = DragGesture()
            .onChanged { val in
                withAnimation {
                    offSize.height = val.translation.height
                }
            }
            .onEnded { _ in
                withAnimation {
                    draggedUp.toggle()
                    offSize.height = 0
                }
            }
        
        TextField("我想说什么来着",text: $theWord.text)
        // PPT
            .disableAutocorrection(true)
            .foregroundColor(.primary)
            .padding(5)
            .font(.headline)
            .background(.gray)
            .cornerRadius(5)
            .brightness(0.3)
            .padding(10)
            .padding(.horizontal,20)
            .shadow(color: .primary, radius: 2)
            .submitLabel(.next)
        // BeHavior
            .onReceive(timer, perform: { _ in
                theWord.secondSpent += 1
            })
        // Gestures and all
            .offset(offSize)
            .disabled(draggedUp)
            .gesture(drag)
    }
}

struct TypeIn_Previews: PreviewProvider {
    static var previews: some View {
        TypeIn(theWord: .constant(Aword(text: "sdaljs", secondSpent: 1, edition: 1)), draggedUp: .constant(true))
    }
}
