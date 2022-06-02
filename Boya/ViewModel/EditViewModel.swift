//
//  EditViewModel.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/1.
//

import SwiftUI
import Combine

class EditViewModel: ObservableObject {
    
    //TODO: pieces for words actually
    private let fileName4pieces = "pieces"
    private let fileName4threads = "threads"
    
    //commit & push words
    @Published var aword = Aword()
    @Published var popword: Aword? = nil
    
    // layer 1
    @Published var wordsPool:[Aword] = []
    
    // layer 2.
    @Published var threads: [String : [Aword]] = [:]
    // keys vector for threads
    @Published var clues: [String] = ["Pop","..."]
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
    }
    
    func getData() {
        loadWords()
        loadThreads()
    }
    
    
    func bindPop2Threads() {
        
        if threads.keys.contains(clues[0]) {
            return
        } else {
            threads[clues[0]] = []
        }
        
    }
    
    // Push layer 1
    func Pressed(pickerAt index:Int) {
        // guard pop happened!
        guard let pop = popword else {return}
        // the clue
        let text = pop.text
        // dynamic array index
        let endIndex = clues.count - 1
        
        // ... for a new thread, 0 for pop
        switch index {
            case endIndex:
                clues.insert(text, at: 1)
                threads[text] = [pop]
                saveThreads()
            
            default:
                bindPop2Threads()
                threads[clues[index]]?.append(pop)
                saveThreads()
        }
        popword = nil
        savePieces()
    }
    
    func submitted() {
        
        let is0word = aword.text == ""
        
        if is0word {
            aword = Aword()
        } else {
            withAnimation {
                wordsPool.append(aword)
            }
            savePieces()
            aword = Aword()
        }
        
    }
    
    func loadThreads() {
        
        do {
            let url4threads = try LocalFileManager.fileURL(fileName: fileName4threads)
            
            URLSession.shared.dataTaskPublisher(for: url4threads)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [[String : [Aword]]].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returned in
                    guard let self = self else {return}
                    if !returned.isEmpty {
                        self.threads = returned[0]
                        let keys = self.threads.keys
                        self.clues.insert(contentsOf: keys , at: 1)
                    }
                })
                .store(in: &cancellables)
            
        } catch {
            print("try LocalFileManager.fileURL()")
        }
        
        
    }
    
    
    func loadWords() {
        do {
            let url4pieces = try LocalFileManager.fileURL(fileName: fileName4pieces)
            
            URLSession.shared.dataTaskPublisher(for: url4pieces)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [Aword].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returnedPieces in
                    self?.wordsPool = returnedPieces
                })
                .store(in: &cancellables)

            
        } catch {
            print("try LocalFileManager.fileURL()")
        }
    }
    
    func savePieces() {
        
        LocalFileManager.save(aCodable: wordsPool, fileName: fileName4pieces)
        print("save savePieces( ) data")
    }
    
    func saveThreads() {
        LocalFileManager.save(aCodable: [threads], fileName: fileName4threads)
        print("saveThreads()")
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        return output.data
    }
    
}
