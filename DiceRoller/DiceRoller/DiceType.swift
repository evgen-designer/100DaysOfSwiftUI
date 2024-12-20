//
//  DiceType.swift
//  DiceRoller
//
//  Created by Mac on 10/12/2024.
//

import Foundation

enum DiceType: Int, CaseIterable, Identifiable {
    case d4 = 4
    case d6 = 6
    case d8 = 8
    case d10 = 10
    case d12 = 12
    case d20 = 20
    case d100 = 100
    
    var id: Int { rawValue }
    
    var name: String {
        "d\(rawValue)"
    }
}
