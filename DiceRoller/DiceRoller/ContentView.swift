//
//  ContentView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var historyManager = RollHistoryManager()
    
    var body: some View {
        TabView {
            NavigationStack {
                DiceRollerView(historyManager: historyManager)
            }
            .tabItem {
                Label("Dices", systemImage: "dice")
            }
            
            NavigationStack {
                RollHistoryView(historyManager: historyManager)
            }
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
    }
}

#Preview {
    ContentView()
}
