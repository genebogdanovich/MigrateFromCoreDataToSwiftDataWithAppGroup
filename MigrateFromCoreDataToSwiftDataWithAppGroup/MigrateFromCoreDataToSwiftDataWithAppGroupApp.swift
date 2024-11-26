//
//  MigrateFromCoreDataToSwiftDataWithAppGroupApp.swift
//  MigrateFromCoreDataToSwiftDataWithAppGroup
//
//  Created by Gene Bogdanovich on 26.11.24.
//

import SwiftUI

@main
struct MigrateFromCoreDataToSwiftDataWithAppGroupApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
