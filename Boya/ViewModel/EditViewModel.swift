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
    private let fileName4wordsPop = "popWords"
    private let fileName4threads = "threads"
    
    //commit & push words
    @Published var aword = Aword()
    @Published var popword: Aword? = nil
    
    // layer 1
    @Published var wordsPop:[Aword] = []
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
        loadPops()
        
        loadThreads()
        
//#warning("one last time get pops")
//        pops2thread()
    }
    
    #warning("one-time func, hotpatch fix")
    // merge wordspop into one of the threads!
    func pops2thread() {
        print(threads.description)
        threads[clues[0]] = wordsPop
        print(threads.description)
        saveThreads()
    }
    
    func deleteWordsPop() {
        LocalFileManager.deleteFile(fileName: fileName4wordsPop)
    }
    
//     pull layer 2
    
    // whate returned is immutable
    func chosenthread(pickerAt index:Int) -> [Aword] {
        return self.threads[clues[index]] ?? self.wordsPop
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
    
    func loadPops() {
       
        do {
            let url4pops = try LocalFileManager.fileURL(fileName: fileName4wordsPop)
            
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
            print("loadPops() ")
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
