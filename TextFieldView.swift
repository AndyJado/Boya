//
//  TextFieldView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/26.
//

import SwiftUI

struct TextFieldView: View {
    
    @State private var text = "text"
    
    var body: some View {
        TextEditor(text: $text)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
