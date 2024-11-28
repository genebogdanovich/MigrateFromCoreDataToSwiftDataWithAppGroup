//
//  Item.swift
//  MigrateFromCoreDataToSwiftDataWithAppGroupWidgetsExtension
//
//  Created by Gene Bogdanovich on 28.11.24.
//

import Foundation
import SwiftData

@Model
class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
