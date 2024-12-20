//
//  DiceRollerView.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import SwiftUI

struct DiceRollerView: View {
    @State private var numberOfDice = 1
    @State private var selectedDiceType: DiceType = .d6
    @State private var diceResults: [Int] = [0]
    @State private var isRolling = false
    @State private var animatedRollValues: [Int] = [0]
    
    @ObservedObject var historyManager: RollHistoryManager
    
    private var diceTypes = DiceType.allCases
    private let columns = [GridItem(.adaptive(minimum: 80))]
    
    init(historyManager: RollHistoryManager) {
        self.historyManager = historyManager
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    Text("Number of dices")
                    Spacer()
                    Picker("Number of dices", selection: $numberOfDice) {
                        ForEach(1...10, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use a compact style like MenuPickerStyle
                    .onChange(of: numberOfDice) { oldValue, newValue in
                        diceResults = Array(repeating: 0, count: newValue)
                        animatedRollValues = Array(repeating: 0, count: newValue)
                    }
                }

                HStack {
                    Text("Dice type")
                    Spacer()
                    Picker("Dice type", selection: $selectedDiceType) {
                        ForEach(diceTypes) { diceType in
                            Text(diceType.name).tag(diceType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Compact style
                }
            }
            .padding()
            .background(.blue.opacity(0.1))
            .cornerRadius(20)
            .padding()
            .navigationTitle("Dices")
            .navigationBarTitleDisplayMode(.inline)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<diceResults.count, id: \.self) { index in
                        VStack {
                            Text("Dice \(index + 1)")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                            Text("\(isRolling ? animatedRollValues[safe: index] ?? 0 : diceResults[safe: index] ?? 0)")
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .frame(maxHeight: 400)
            
            Spacer()
            
            Button(action: rollDice) {
                Text("Roll dice")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isRolling)
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
        }
    }
    
    private func rollDice() {
        isRolling = true
        diceResults = Array(repeating: 0, count: numberOfDice)
        animatedRollValues = Array(repeating: 0, count: numberOfDice)
        
        var rollCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            for i in 0..<numberOfDice {
                animatedRollValues[i] = Int.random(in: 1...selectedDiceType.rawValue)
            }
            rollCount += 1
            
            if rollCount >= 10 {
                timer.invalidate()
                diceResults = (0..<numberOfDice).map { _ in
                    Int.random(in: 1...selectedDiceType.rawValue)
                }
                
                let result = RollResult(
                    diceType: selectedDiceType.rawValue,
                    numberOfDice: numberOfDice,
                    total: diceResults.reduce(0, +),
                    individualResults: diceResults
                )
                historyManager.saveRoll(result)
                isRolling = false
            }
        }
        timer.fire()
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    DiceRollerView(historyManager: RollHistoryManager())
}

