//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Mac on 15/11/2024.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
