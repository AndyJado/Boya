//
//  EditViewModel.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/1.
//

import SwiftUI
import os.log

final class EditViewModel: ObservableObject {
    
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
    
    @AppStorage("popSec") var popSec: Int = 0
    @AppStorage("popEdition") var popEdition: Int = 0
    
    init() {
        loadData()
    }
    
//    func getData() async {
//        await loadWords()
//        await asyncLoadThreads()
//        await loadCacheThreads()
//    }
    
    func loadData() {
        
        Task {
            await loadWords()
        }
        Task {
            await asyncLoadThreads()
        }
        Task {
            await loadCacheThreads()
        }
    }
    
    
    func threadRemoval(at picking:Int) {
        threads.removeValue(forKey: clues[picking])
        clues.remove(at: picking)
        
    }
    
    func thread2Pool(clue: String) {
        // thread not empty
        if let i = threads[clue]?.first {
            wordsPool.insert(i, at: 0)
            threads[clue]?.remove(at: 0)
        } else {
            return
        }
    }
    
    func Pool2Thread(clue: String) {
        // Pool not empty
        guard let cover = wordsPool.last?.text else {return}
        // current clue
        switch clue {
        // new clue
        case "..." :
            threads.updateValue(wordsPool, forKey: cover)
            clues.insert(cover, at: 1)
        // suck poping life
        case "Pop" :
            for word in wordsPool {
                popSec += word.secondSpent
                popEdition += word.edition
            }
        // append to exsisting clue
        default:
            threads[clue]?.append(contentsOf: wordsPool)
        }
        // Poolremove
        wordsPool.removeAll()
    }
    
    func cacheBack(for key: String) {
        if let thread = threadsCache.removeValue(forKey: key) {
            threads.updateValue(thread, forKey: key)
            clues.insert(key, at: 1)
        }
    }
    
    func cacheThread(at picking: Int) {
        
        if let thread = threads.removeValue(forKey: clues[picking]) {
            let key  = clues.remove(at: picking)
            threadsCache.updateValue(thread, forKey: key)
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
            
        case 0:
            break
            
        default:
            threads[clues[index]]?.append(pop)
        }
        //        popword = nil
    }
    
    func submitted() {
        
        let is0word = aword.text == ""
        
        if is0word {
            aword = Aword()
        } else {
            withAnimation {
                wordsPool.append(aword)
            }
            aword = Aword()
        }
        
    }
    
    func asyncLoadThreads() async {
        do {
            let url4threads = try LocalFileManager.fileURL(fileName: EditViewModel.fileName4threads)
            let (data, _) = try await URLSession.shared.data(from: url4threads)
            let returned = try JSONDecoder().decode([[String : [Aword]]].self, from: data)
            
            Task { @MainActor [weak self] in
                guard let self = self else {return}
                if !returned.isEmpty {
                    self.threads = returned[0]
                    let keys = self.threads.keys
                    self.clues.insert(contentsOf: keys , at: 1)
                }
            }
                
        }catch {
            logger.error("asyncLoadThreads!")
        }
    }
    
    func loadWords() async {
        do {
            let url4pieces = try LocalFileManager.fileURL(fileName: EditViewModel.fileName4pieces)
            let (data, _) = try await URLSession.shared.data(from: url4pieces)
            let returned = try JSONDecoder().decode([Aword].self, from: data)
            
            Task { @MainActor [weak self] in
                guard let self = self else {return}
                if !returned.isEmpty {
                    self.wordsPool = returned
                }
            }
            
        } catch {
            logger.error("try LocalFileManager.fileURL()")
        }
    }
    
    func loadCacheThreads() async {
        
        do {
            let url4threads = try LocalFileManager.fileURL(fileName: WordsForm.cacheThreads.fileName())
            let (data, _) = try await URLSession.shared.data(from: url4threads)
            let returned = try JSONDecoder().decode([[String : [Aword]]].self, from: data)
            
            Task { @MainActor [weak self] in
                guard let self = self else {return}
                if !returned.isEmpty {
                    self.threadsCache = returned[0]
                }
            }
            
        } catch {
            logger.error("loadCacheThreads()")
        }
        
    }
    
    func savePieces() {
        
//        guard !wordsPool.isEmpty else {return}
        
        LocalFileManager.save(aCodable: wordsPool, fileName: EditViewModel.fileName4pieces)
        logger.debug("save savePieces( ) data")
    }
    
    func saveCacheThreads() {
        
//        guard !threadsCache.isEmpty else {return}
        
        LocalFileManager.save(aCodable: [threadsCache], fileName: EditViewModel.CachedThreadsFile)
        logger.debug("save saveCacheThreads( ) data")
    }
    
    
    //TODO: [threads] not threads! redadent move!
    func saveThreads() {
        
//        guard !threads.isEmpty else {return}
        
        LocalFileManager.save(aCodable: [threads], fileName: EditViewModel.fileName4threads)
        logger.debug("saveThreads()")
    }
    
    func saveAll() {
        
        savePieces()
        
        saveThreads()
        
        saveCacheThreads()
    }
    
    
}

fileprivate let logger = Logger.init(subsystem: "com.andyjao.Boya", category: "Layer.WordPool")
