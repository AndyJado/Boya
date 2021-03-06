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
    
    static func save<T:Codable>(aCodable: [T], fileName:String) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(aCodable)
                let outfile = try fileURL(fileName: fileName)
                try data.write(to: outfile)
            } catch {
                DispatchQueue.main.async {
                   print("LocalFileManager)")
                }
            }
        }
    }
    
    static func deleteFile(fileName:String) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL(fileName: fileName)
               try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("deleteFIle local manager")
            }
        }
    }
    
}
