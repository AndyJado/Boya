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
    static let fileName4pieces = "pieces"
    static let fileName4threads = "threads"
    static let CachedThreadsFile = "threadsCached"
    
    
    //commit & push words
    @Published var aword = Aword()
    @Published var popword: Aword? = nil
    
    // layer 1
    @Published var wordsPool:[Aword] = []
    
    // layer 2.
    @Published var threads: [String : [Aword]] = [:]
    @Published var threadsCache:[String : [Aword]] = [:]
    // keys vector for threads
    @Published var clues: [String] = ["Pop","..."]
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
    }
    
    func getData() {
        loadWords()
        loadThreads()
        loadCacheThreads()
        
//        DispatchQueue.global(qos: .background).async {
//            self.loadCacheThreads()
//        }
    }
    
    func threadRemoval(at picking:Int) {
        threads.removeValue(forKey: clues[picking])
        clues.remove(at: picking)

    }
    
    func cacheBack(for key: String) {
        if let thread = threadsCache.removeValue(forKey: key) {
            threads.updateValue(thread, forKey: key)
            clues.insert(key, at: 1)
            saveCacheThreads()
            saveThreads()
        }
    }
    
    func cacheThread(at picking: Int) {
        
        if let thread = threads.removeValue(forKey: clues[picking]) {
            let key  = clues.remove(at: picking)
            threadsCache.updateValue(thread, forKey: key)
            saveCacheThreads()
            saveThreads()
        }
    }
    
    // Push layer 1
    func pressedAct(pickerAt index:Int) {
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
            
            case 0:
                break
                
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
            let url4threads = try LocalFileManager.fileURL(fileName: EditViewModel.fileName4threads)
            
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
            let url4pieces = try LocalFileManager.fileURL(fileName: EditViewModel.fileName4pieces)
            
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
    
    func loadCacheThreads() {
        do {
            let url4threads = try LocalFileManager.fileURL(fileName: EditViewModel.CachedThreadsFile)

            URLSession.shared.dataTaskPublisher(for: url4threads)
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode(type: [[String : [Aword]]].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .sink(receiveValue: { [weak self] returned in
                    guard let self = self else {return}
                    if !returned.isEmpty {
                        self.threadsCache = returned[0]
                    }
                })
                .store(in: &cancellables)

        } catch {
            print("loadCacheThreads() !!")
        }

    }
    
    func savePieces() {
        
        LocalFileManager.save(aCodable: wordsPool, fileName: EditViewModel.fileName4pieces)
        print("save savePieces( ) data")
    }
    
    func saveCacheThreads() {
        
        LocalFileManager.save(aCodable: [threadsCache], fileName: EditViewModel.CachedThreadsFile)
        print("save saveCacheThreads( ) data")
    }

    
    //TODO: [threads] not threads! redadent move!
    func saveThreads() {
        LocalFileManager.save(aCodable: [threads], fileName: EditViewModel.fileName4threads)
        print("saveThreads()")
    }
    
    func saveAll() {
        
        savePieces()
        
        saveThreads()
        
    }
    
    
}
