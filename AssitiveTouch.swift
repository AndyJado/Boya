//
//  AssitiveTouch.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/9.
//

import SwiftUI
import WebKit
 
struct FloatingFab : View {
    var body: some View {
        ZStack {
            WebView(request: URLRequest(url: URL(string: "https://stackoverflow.com/")!))
 
            FloatingView()
        }
    }
}
 
struct WebView : UIViewRepresentable {
 
    let request: URLRequest
 
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
 
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
 
}
 
struct FloatingView: View {
 
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
 
    var body: some View {
 
        ZStack {
            Circle()
                .foregroundColor(.gray)
                .frame(width: 80, height: 80)
                .opacity(0.2)
            Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                .onTapGesture(perform: {
                    debugPrint("Perform you action here")
                })
                .gesture(DragGesture()
                    .onChanged { value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width,
                                                      height: value.translation.height + self.newPosition.height)
                }
                .onEnded { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width,
                                                  height: value.translation.height + self.newPosition.height)
     
                    self.newPosition = self.currentPosition
                    }
            )
        }
    }
}

struct AssitiveTouch_Previews: PreviewProvider {
    static var previews: some View {
        FloatingFab()
    }
}
