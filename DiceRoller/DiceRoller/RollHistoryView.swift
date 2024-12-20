//
//  RollHistoryView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct RollHistoryView: View {
    @ObservedObject var historyManager: RollHistoryManager
    
    var body: some View {
        List {
            ForEach(historyManager.rollHistory) { roll in
                HStack {
                    VStack(alignment: .leading) {
                        Text("d\(roll.diceType) x \(roll.numberOfDice)")
                            .font(.headline)
                        Text(roll.timestamp, format: .dateTime.day().month(.abbreviated).year().hour().minute())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(roll.total)")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
        .navigationTitle("Roll history")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear history") {
                    historyManager.clearHistory()
                }
            }
        }
    }
}

#Preview {
    let historyManager = RollHistoryManager()
    // Add some sample data for the preview
    historyManager.saveRoll(RollResult(diceType: 6, numberOfDice: 2, total: 7, individualResults: [3, 4]))
    historyManager.saveRoll(RollResult(diceType: 20, numberOfDice: 1, total: 18, individualResults: [18]))
    historyManager.saveRoll(RollResult(diceType: 12, numberOfDice: 3, total: 25, individualResults: [8, 9, 8]))
    
    return NavigationView {
        RollHistoryView(historyManager: historyManager)
    }
}
