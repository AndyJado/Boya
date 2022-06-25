//
//  EditViewModel.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/1.
//

import SwiftUI
import os.log

final class EditViewModel: ObservableObject {
    
    let timeAcotr = TimingManager()
    
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
    
    private var isloaded = false
    
    init() {
//        loadAll()
        Task{ try await asyncLoadAll()}
    }
    
    func loadAll() {
        
        guard !isloaded else {return}
        
        Task { try await self.loadWords()}
        Task { try await self.asyncLoadThreads()}
        Task { try await self.loadCacheThreads()}
        
        isloaded = true
    }
    
    func asyncLoadAll() async throws {
        
        guard !isloaded else {return}
        
        await withThrowingTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask { try await self.loadWords() }
            taskGroup.addTask { try await self.asyncLoadThreads() }
            taskGroup.addTask { try await self.loadCacheThreads() }
        }
        self.isloaded.toggle()
        
    }
    
    
    func thread2Pool(_ picking: inout Int) {
        let clue = clues[picking]
        switch clue {
        case "Pop":
            picking += 1
        case "...":
            if let freshCahe = threadsCache.keys.first {
                cacheBack(for: freshCahe )
            }
        default:
            if let word = threads[clue]?.first {
                wordsPool.insert(word, at: 0)
                threads[clue]?.remove(at: 0)
            } else {
                threads.removeValue(forKey: clue)
                clues.remove(at: picking)
            }
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
        } else {
            logger.error("cacheBack(for key: String)")
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
        
        Task {
            await timeAcotr.endFocus()
            
            if aword.text == "" {
                
                await timeAcotr.clearHand()
                
                Task {@MainActor in
                    aword = Aword()
                }
            } else {
                Task {@MainActor in
                    aword.secondSpent += await timeAcotr.handClose()
                    withAnimation {
                        wordsPool.append(aword)
                    }
                    aword = Aword()
                }
            }
        }
        
        
    }
    
    func asyncLoadThreads() async throws {
        let url4threads = try LocalFileManager.fileURL(fileName: WordsForm.threads.fileName)
        let (data, _) = try await URLSession.shared.data(from: url4threads)
        let returned = try JSONDecoder().decode([[String : [Aword]]].self, from: data)
        
        Task { @MainActor  in
            self.threads = returned[0]
            let keys = self.threads.keys
            self.clues.insert(contentsOf: keys , at: 1)
        }
        
        logger.debug("loadThreads")
    }
    
    func loadWords() async throws {
        
        
        let url4pieces = try LocalFileManager.fileURL(fileName: WordsForm.words.fileName)
        let (data, _) = try await URLSession.shared.data(from: url4pieces)
        let returned = try JSONDecoder().decode([Aword].self, from: data)
        
        Task { @MainActor  in
            self.wordsPool = returned
        }
        logger.debug("loadWords")
    }
    
    func loadCacheThreads() async throws {
        
        
        let url4threads = try LocalFileManager.fileURL(fileName: WordsForm.cacheThreads.fileName)
        let (data, _) = try await URLSession.shared.data(from: url4threads)
        let returned = try JSONDecoder().decode([[String : [Aword]]].self, from: data)
        
        Task { @MainActor  in
            self.threadsCache = returned[0]
        }
        logger.debug("loadCacheTrheads")
    }
    
    func savePieces() async{
        
        //        guard !wordsPool.isEmpty else {return}
        
        LocalFileManager.save(aCodable: wordsPool, fileName: WordsForm.words.fileName)
        logger.debug("save saveWords( ) data")
    }
    
    func saveCacheThreads() async{
        
        //        guard !threadsCache.isEmpty else {return}
        
        LocalFileManager.save(aCodable: [threadsCache], fileName: WordsForm.cacheThreads.fileName)
        logger.debug("save saveCacheThreads( ) data")
    }
    
    
    //TODO: [threads] not threads! redadent move!
    func saveThreads() async{
        
        //        guard !threads.isEmpty else {return}
        
        LocalFileManager.save(aCodable: [threads], fileName: WordsForm.threads.fileName)
        logger.debug("saveThreads()")
    }
    
    func saveAll() {
        guard isloaded else {return}
        Task{ await savePieces() }
        Task{ await saveThreads() }
        Task{ await saveCacheThreads() }
    }
    
}

fileprivate let logger = Logger.init(subsystem: "com.andyjao.Boya", category: "Layer.WordPool")
