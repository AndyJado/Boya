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

enum piecesPool {
    case Pops
    case FirstInAsTitle
}

class EditViewModel: ObservableObject {
    
    //TODO: pieces for words actually
    private let fileName4pieces = "pieces"
    private let fileName4wordsPop = "popWords"
    
    
    @Published var aword = Aword()
    @Published var wordsPop:[Aword] = []
    @Published var wordsPool:[Aword] = []
    @Published var piecesPool: [String : [Aword]] = [:]
    
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
        
        if let piece = piecesPool[word.text] {
            print(piece.description)
        } else {
            print(piecesPool.description)
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
    
    @FocusState private var focuing: Bool
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            // 双击退回编辑 (没有保存动作)
            // 长按进入pop (pop保存)
            LazyGridView(items: $viewModel.wordsPool, currentWord: $viewModel.aword, popeditems: $viewModel.wordsPop, Tapaction: {focuing.toggle()}, action: viewModel.savePops)
                .opacity(focuing ? 0.35 : 1)
                .blur(radius: focuing ? 1.6 : 0)
                .disabled(focuing)
            
            
            Spacer()
            
            
            TypeIn(textInField: $viewModel.aword.text)
                .focused($focuing)
                .onReceive(timer) { _ in
                    viewModel.aword.secondSpent += 1
                }
                .onSubmit {
                    viewModel.words2piece(word: viewModel.aword )
                    viewModel.submitted()
                    focuing = true
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
