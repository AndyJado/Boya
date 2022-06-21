//
//  Data.swift
//  Boya
//
//  Created by Andy Jado on 2022/6/1.
//

import Foundation

struct Aword:Hashable, Codable {
    var text: String = ""
    var secondSpent: Int = 0
    var edition: Int = 1
}

let TestThread:[Aword] = [Aword(text: "a", secondSpent: 90, edition: 4), Aword(text: "asasa", secondSpent: 30, edition: 2),Aword(text: "a", secondSpent: 90, edition: 4), Aword(text: "asasa", secondSpent: 30, edition: 2),Aword(text: "a", secondSpent: 90, edition: 4), Aword(text: "asasa", secondSpent: 30, edition: 2),Aword(text: "a", secondSpent: 90, edition: 4), Aword(text: "asasa", secondSpent: 30, edition: 2)]

enum WordsForm {
    
    case words
    case threads
    case cacheThreads
    
    func fileName() -> String {
        switch self {
        case .words:
            return "pieces"
        case .threads:
            return "threads"
        case .cacheThreads:
            return "threadsCached"
        }
    }
    
}

enum Clues {
    case ddDot
    case Pop
    case clue(i:Int)
}

