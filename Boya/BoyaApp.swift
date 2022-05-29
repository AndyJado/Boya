//
//  BoyaApp.swift
//  Boya
//
//  Created by Andy Jado on 2022/5/7.
//

import SwiftUI

@main
struct BoyaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            EditView()
        }
    }
}
