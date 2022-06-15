//
//  LazyGridView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/19.
//

import SwiftUI


struct WordPoolView: View {
    
    
    @Binding var items: [Aword]
    @Binding var currentItem: Aword
    @Binding var currentPop: Aword?
    
    // external action
    let tap2Action: (() -> Void)
    let pressAction: (() -> Void)
    let pinchAction: (() -> Void)
    
    // state flag
    @State private var tapped:Bool = false
    @State private var tapp2ed:Bool = false
    @State private var pressed:Bool = false
    
    
    private let spacingBetweenRows: CGFloat = 0
    private let gridItems: [GridItem] = Array(repeating: GridItem(.fixed(20), spacing: 25, alignment: .topLeading), count: 15)
    
    var body: some View {
        
        let count = items.count
        let wordFly = Animation.spring()
        let UIsize:CGSize = UIScreen.main.bounds.size
        
        ScrollView(
            [.vertical,.horizontal],
            showsIndicators: false) {
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
                            
                            let longPress = LongPressGesture(minimumDuration: 0.1)
                                .onEnded { _ in
                                    pressed.toggle()
                                    // pop at index i!
                                    currentPop = items.popAt(at: i)
                                    pressAction()
                                }
                            
                            
                            let attributedString = try! AttributedString(markdown: items[i].text)
                            
                            Text(attributedString)
                                .minimumScaleFactor(0.1)
                                .lineLimit(1)
                                .padding(.horizontal)
                            // TODO: this id is from some kind of customizd view
                                .id(i)
                                .Yoffset(at: i, in: count)
                                .frame(width:UIsize.width,height: 20,alignment: .topLeading)
                            // gestures
                                .highPriorityGesture(ExclusiveGesture(tap2, tap1))
                                .gesture(longPress)
                            
                        }

                    }
//                    .padding(.bottom,100)
                    
            }
            .padding(.bottom, 20)
            
    }
    
}
struct LazyGridView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        WordPoolView(items: .constant([Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa")]), currentItem: .constant(Aword()), currentPop: .constant(nil), tap2Action: {}, pressAction: {}, pinchAction: {})
    }
}

