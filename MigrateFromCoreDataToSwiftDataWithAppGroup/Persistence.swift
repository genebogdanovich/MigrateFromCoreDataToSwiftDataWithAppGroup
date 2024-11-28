//
//  Persistence.swift
//  MigrateFromCoreDataToSwiftDataWithAppGroup
//
//  Created by Gene Bogdanovich on 26.11.24.
//

import CoreData
import OSLog

// MARK: - PersistenceController

struct PersistenceController {
    private let logger = Logger(subsystem: "com.genebogdanovich.MigrateFromCoreDataToSwiftDataWithAppGroup.PersistenceController", category: "Persistence")
    
    static let shared = PersistenceController()
    
    private let modelName = "MigrateFromCoreDataToSwiftDataWithAppGroup"
    
    private var originalStoreURL: URL {
        let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let url = applicationSupportDirectoryURL.appending(path: "\(modelName).sqlite")
        
        return url
    }
    
    private var sharedStoreURL: URL {
        let applicationSupportDirectoryURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.genebogdanovich.MigrateFromCoreDataToSwiftDataWithAppGroup")!
        let url = applicationSupportDirectoryURL.appending(path: "\(modelName).sqlite")
        
        return url
    }
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: modelName)
        
        if FileManager.default.fileExists(atPath: originalStoreURL.path(percentEncoded: false)) {
            container.persistentStoreDescriptions.first!.url = originalStoreURL
            logger.log("Using the original store URL.")
        } else {
            // This clause covers the after-migration path and the case where the user installs a fresh copy of the app.
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
            logger.log("Using the shared store URL.")
        }
        
        container.loadPersistentStores(completionHandler: handleLoadPersistentStores)
        
        /*
         In case where we want to migrate the persistent store to an app group container, we can only initiate migration after the store is loaded.
         */
        
        if container.persistentStoreCoordinator.persistentStore(for: originalStoreURL) != nil {
            try! migrateStoreToAppGroupContainer()
            
        } else {
            logger.log("Migration will not execute.")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private func migrateStoreToAppGroupContainer() throws {
        
        // Migrate
        try container.persistentStoreCoordinator.replacePersistentStore(at: sharedStoreURL, withPersistentStoreFrom: originalStoreURL, type: .sqlite)
        
        // Delete the old store
        try container.persistentStoreCoordinator.destroyPersistentStore(at: originalStoreURL, type: .sqlite)
        try FileManager.default.removeItem(at: originalStoreURL)
        
        // Load the new store
        container.persistentStoreDescriptions.first!.url = sharedStoreURL
        container.loadPersistentStores(completionHandler: handleLoadPersistentStores)
        
        logger.log("The migration was successful!")
    }
    
    private func handleLoadPersistentStores(description: NSPersistentStoreDescription, error: Error?) {
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        logger.log("Loaded store: \(description.description)")
    }
}
