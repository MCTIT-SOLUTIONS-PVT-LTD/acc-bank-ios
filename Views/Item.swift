//
//  Item.swift
//  LoginPageTest
//
//  Created by MCT on 12/02/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
