//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Mac on 05/09/2024.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
