//
//  FileManager.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/21.
//

import SwiftUI

class LocalFileManager {
    
    
    static func fileURL(fileName:String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent(fileName)
    }
    
    static func save<T:Codable>(pieces: [T], fileName:String) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(pieces)
                let outfile = try fileURL(fileName: fileName)
                try data.write(to: outfile)
            } catch {
                DispatchQueue.main.async {
                   print("LocalFileManager)")
                }
            }
        }
    }
}
