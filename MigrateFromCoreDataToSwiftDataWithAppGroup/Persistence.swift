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
    
    private var persistentStoreURL: URL {
        let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupportDirectoryURL.appending(path: "\(modelName).sqlite")
    }
    
    
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: modelName)
        if inMemory {
            container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions[0].url = persistentStoreURL
        }
        
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}






// MARK: - Preview

extension PersistenceController {
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
