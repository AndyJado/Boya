//
//  EditView.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/17.
//

import SwiftUI
import Combine

struct Aword:Hashable, Codable {
    
    var text: String = ""
    var secondSpent: Int = 0
    var edition: Int = 1
    
}

class EditViewModel: ObservableObject {
    
    //TODO: pieces for words actually
    private let fileName4pieces = "pieces"
    private let fileName4wordsPop = "popWords"
    
    
    @Published var aword = Aword()
    @Published var wordsPop:[Aword] = []
    @Published var wordsPool:[Aword] = []
    @Published var threads: [String : [Aword]] = [:]
    @Published var clues: [String] = ["Pop","...","Pop","...","Pop","...","Pop","...","Pop","...","Pop","...","Pop","...","Pop","...","Pop","...","Pop","...","Pop","..."]
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        loadWords()
    }
    
    func submitted() {
        
        if aword.text == "" {
            aword = Aword()
        } else {
            withAnimation {
                wordsPool.append(aword)
            }
            savePieces()
            aword = Aword()
        }
        
    }
    
    func words2piece(word: Aword) {
        
        if let piece = threads[word.text] {
            print(piece.description)
        } else {
            print(threads.description)
        }
    }
    
    func loadWords() {
        do {
            let url4pieces = try LocalFileManager.fileURL(fileName: fileName4pieces)
            let url4pops = try LocalFileManager.fileURL(fileName: fileName4wordsPop)
            
            URLSession.shared.dataTaskPublisher(for: url4pieces)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [Aword].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returnedPieces in
                    self?.wordsPool = returnedPieces
                })
                .store(in: &cancellables)
            
            URLSession.shared.dataTaskPublisher(for: url4pops)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [Aword].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returnedpops in
                    self?.wordsPop = returnedpops
                })
                .store(in: &cancellables)
            
        } catch {
            print("try LocalFileManager.fileURL()")
        }
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        return output.data
    }
    
    func savePieces() {
        LocalFileManager.save(pieces: wordsPool, fileName: fileName4pieces)
        print("save savePieces( ) data")
    }
    
    func savePops() {
        LocalFileManager.save(pieces: wordsPop, fileName: fileName4wordsPop)
        print("save  savePops()  data")
    }
    
    
}

struct EditView: View {
    
    @StateObject private var viewModel = EditViewModel()
    
    @State private var picking:Int = 0
    @State private var dragged:Bool = false
    @FocusState private var focuing: Bool
    
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            // 双击退回编辑 (没有保存动作)
            // 长按进入pop (pop保存)
            LazyGridView(items: $viewModel.wordsPool, currentItem: $viewModel.aword, popeditems: $viewModel.wordsPop, tap2Action: {focuing.toggle()}, pressAction: viewModel.savePops)
                .opacity(focuing ? 0.35 : 1)
                .blur(radius: focuing ? 1.6 : 0)
                .disabled(focuing)
            
            
            Spacer()
            
            TypeIn(theWord: $viewModel.aword, draggedUp: $dragged)
                .focused($focuing)
                .onSubmit {
                    viewModel.words2piece(word: viewModel.aword)
                    viewModel.submitted()
                    focuing = true
                }
            
            if dragged {
                PickView(clues: $viewModel.clues, picking: $picking)
            }
            
        }
        .onTapGesture {
            focuing.toggle()
        }
    }
    
}
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
