//
//  RollHistoryManager.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import Foundation

class RollHistoryManager: ObservableObject {
    @Published var rollHistory: [RollResult] = []
    private let historyKey = "diceRollHistory"
    
    init() {
        loadHistory()
    }
    
    func saveRoll(_ roll: RollResult) {
        rollHistory.insert(roll, at: 0)
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(rollHistory) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        guard let savedRolls = UserDefaults.standard.object(forKey: historyKey) as? Data,
              let decodedRolls = try? JSONDecoder().decode([RollResult].self, from: savedRolls) else {
            return
        }
        rollHistory = decodedRolls
    }
    
    func clearHistory() {
        rollHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}
