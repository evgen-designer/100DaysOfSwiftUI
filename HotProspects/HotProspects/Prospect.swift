//
//  Prospect.swift
//  HotProspects
//
//  Created by Eugene Evgen on 15/11/2024.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    private var _dateAdded = Date()
    
    var dateAdded: Date {
        get { _dateAdded }
        set { _dateAdded = newValue }
    }
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
