//
//  LazyGridView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/19.
//

import SwiftUI

struct StackItemModifier: ViewModifier {
    
    let Index: Int
    let count: Int
    
    func body(content: Content) -> some View {
        content
            .offset(x: 0, y: 0)
    }
}

extension View {
    
    func Yoffset(at index: Int, in count: Int) -> some View {
        modifier(StackItemModifier(Index: index, count: count))
    }
    
}

struct LazyGridView: View {
    
    
    @Binding var items: [Aword]
    @Binding var currentWord: Aword
    @Binding var popeditems: [Aword]
    
    var Tapaction: (() -> Void)
    var action: (() -> Void)
    
    
    @State private var tapped:Bool = false
    @State private var tapp2ed:Bool = false
    @State private var pressed:Bool = false
    
    
    private let itemSize = CGSize(width: sizeManager.UIsize.width, height: 20)
    private let spacingBetweenRows: CGFloat = 0
    
    private let gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 10, maximum: 1000), spacing: 20, alignment: .topLeading), count: 15)
    
    var body: some View {
        
        let count = items.count
        
        
        
        ScrollView(
            [.vertical,.horizontal],
            showsIndicators: false) {
                
                
                ScrollViewReader { scroll in
                    LazyHGrid(
                        rows: gridItems,
                        alignment: .firstTextBaseline, spacing: spacingBetweenRows,
                        pinnedViews: .sectionHeaders) {
                            
                            
                            ForEach((0..<count).reversed(),id: \.self) { i in
                                
                                let tap1 = TapGesture()
                                    .onEnded { _ in
                                        withAnimation {
                                            tapped.toggle()
                                            UIPasteboard.general.setValue(items[i].text, forPasteboardType: "public.plain-text")
                                        }
                                    }
                                
                                let tap2 = TapGesture(count: 2)
                                    .onEnded { _ in
                                        withAnimation(Animation.easeOut) {
                                            tapp2ed.toggle()
                                            currentWord = items[i]
                                            currentWord.edition += 1
                                            items.remove(at: i)
                                            Tapaction()
                                        }
                                    }
                                
                                let longPress = LongPressGesture()
                                    .onEnded { _ in
                                        withAnimation(Animation.easeOut) {
                                            pressed.toggle()
                                            popeditems.append(items[i])
                                            action()
                                            items.remove(at: i)
                                        }
                                    }
                                
                                
                                
                                Text(items[i].secondSpent.description + "s. " + items[i].text)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(1)
                                    .padding(.horizontal)
                                    .id(i)
                                    .Yoffset(at: i, in: count)
                                    .frame(height: 20)
                                    .highPriorityGesture(ExclusiveGesture(tap2, tap1))
                                    .gesture(longPress)
                            }
                            
                        }
                        .task {
                            
                            withAnimation(.spring().speed(0.2)) {
                                
                                if items.isEmpty {
                                    return
                                } else {
                                    scroll.scrollTo(Int.random(in: items.indices),anchor: .bottomTrailing)
                                }
                            }
                        }
                }
            }
    }
    
    func playSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}
struct LazyGridView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        LazyGridView(items: .constant([Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa")]), currentWord: .constant(Aword()), popeditems: .constant([Aword(),]), Tapaction: {}, action: {})
    }
}

