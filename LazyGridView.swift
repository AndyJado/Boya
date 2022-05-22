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
    var action: (() -> Void)
    
    private let itemSize = CGSize(width: sizeManager.UIsize.width, height: 20)
    private let spacingBetweenRows: CGFloat = 5
    
    
    
    var body: some View {
        
        let count = items.count
        
        ScrollView(
            [.vertical,.horizontal],
            showsIndicators: false) {
                
                ScrollViewReader { scroll in
                    LazyVStack(
                        alignment: .leading, spacing: spacingBetweenRows,
                        pinnedViews: .sectionHeaders) {
                            
                            
                            ForEach((0..<count).reversed(),id: \.self) { i in
                                
                                Text(items[i].text)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(1)
                                    .padding(.horizontal)
                                    .frame(minWidth: sizeManager.UIsize.width,alignment: .leading)
                                    .id(i)
                                    .Yoffset(at: i, in: count)
                                    .onTapGesture(count:2) {
                                        currentWord = items[i]
                                        currentWord.edition += 1
                                        items.remove(at: i)
                                    }
                                    .onLongPressGesture {
                                        popeditems.append(items[i])
                                        action()
                                        items.remove(at: i)
                                    }
                            }
                            
                        }
                        .task {
                            
                            withAnimation(.spring().speed(0.2)) {
                                
                                if items.isEmpty {
                                    return
                                } else {
                                    scroll.scrollTo(Int.random(in: items.indices),anchor: .center)
                                }
                            }
                        }
                }
                .padding(0)
            }
    }
    
    func playSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}
struct LazyGridView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        LazyGridView(items: .constant([Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa"),Aword(text:"sasa"),Aword(text:"sssasa")]), currentWord: .constant(Aword()), popeditems: .constant([Aword(),]), action: {})
    }
}

