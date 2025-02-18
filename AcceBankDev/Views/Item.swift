//
//  Item.swift
//  AcceBankDev
//
//  Created by MCT on 17/02/25.
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
