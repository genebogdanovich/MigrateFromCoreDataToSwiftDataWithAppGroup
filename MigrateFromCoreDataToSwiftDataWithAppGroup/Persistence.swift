//
//  Persistence.swift
//  MigrateFromCoreDataToSwiftDataWithAppGroup
//
//  Created by Gene Bogdanovich on 26.11.24.
//

import CoreData

// MARK: - PersistenceController

struct PersistenceController {
    static let shared = PersistenceController()
    
    private let modelName = "MigrateFromCoreDataToSwiftDataWithAppGroup"
    
    private var initialStoreURL: URL {
        let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupportDirectoryURL.appending(path: "\(modelName).sqlite")
    }
    
    
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: modelName)
        
        container.persistentStoreDescriptions[0].url = initialStoreURL
        
        
        
        container.loadPersistentStores(completionHandler: handleLoadPersistentStores)
        
        
        
        
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
    private func handleLoadPersistentStores(description: NSPersistentStoreDescription, error: Error?) {
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        print("Loaded store: \(description.description)")
    }
    
    
}




