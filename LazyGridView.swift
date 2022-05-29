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
    @Binding var currentItem: Aword
    @Binding var currentPop: Aword?
    
    // external action
    var tap2Action: (() -> Void) = {}
    var pressAction: (() -> Void) = {}
    
    
    @State private var tapped:Bool = false
    @State private var tapp2ed:Bool = false
    @State private var pressed:Bool = false
    
    
    private let itemSize = CGSize(width: sizeManager.UIsize.width, height: 20)
    private let spacingBetweenRows: CGFloat = 0
    
    private let gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 10, maximum: 1000), spacing: 20, alignment: .topLeading), count: 15)
    
    var body: some View {
        
        let count = items.count
        let wordFly = Animation.easeInOut.speed(0.2)
        
        
        
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
                                        tapped.toggle()
                                        UIPasteboard.general.setValue(items[i].text, forPasteboardType: "public.plain-text")
                                    }
                                
                                let tap2 = TapGesture(count: 2)
                                    .onEnded { _ in
                                        withAnimation(wordFly) {
                                            tapp2ed.toggle()
                                            currentItem = items[i]
                                            currentItem.edition += 1
                                            items.remove(at: i)
                                            tap2Action()
                                        }
                                    }
                                
                                let longPress = LongPressGesture()
                                    .onEnded { _ in
//                                        withAnimation(wordFly) {
//                                            pressed.toggle()
//                                            popsCatcher.append(items[i])
//                                            pressAction()
//                                            items.remove(at: i)
//                                        }
                                        withAnimation(wordFly) {
                                            pressed.toggle()
                                            // pop at index i!
                                            currentPop = items.popAt(at: i)
                                            pressAction()
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
        LazyGridView(items: .constant([Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa")]), currentItem: .constant(Aword()), currentPop: .constant(nil), tap2Action: {}, pressAction: {})
    }
}

