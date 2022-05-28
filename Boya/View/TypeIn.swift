//
//  TypeIn.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/18.
//

import SwiftUI

struct TypeIn: View {
    
    @Binding var textInField: String
    
    var body: some View {
            
        
            TextField("",text: $textInField)
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
//                .background(.gray)
//                .frame(maxWidth: .infinity)
                .submitLabel(.next)
    }
}

struct TypeIn_Previews: PreviewProvider {
    static var previews: some View {
        TypeIn(textInField: .constant("sasaas"))
    }
}
