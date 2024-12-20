//
//  Mission.swift
//  Moonshot
//
//  Created by Mac on 18/07/2024.
//

import Foundation

struct Mission: Codable, Identifiable, Hashable {
    struct CrewRole: Codable, Hashable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    // Conformance to Equatable and Hashable is automatic if all properties are Hashable
    
    //MARK: Day 76. Project 15 challenge
    var accessibleLaunchDate: String {
        formattedLaunchDate.replacingOccurrences(of: "Launch date N/A", with: "Launch date is not found")
    }
}
