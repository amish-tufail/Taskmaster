//
//  Persistence.swift
//  Taskmaster
//
//  Created by Amish Tufail on 05/03/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController() // 1. Persistence Controller
    let container: NSPersistentContainer // 2. Persistence Container
    // 3. INIT -> Load the persistent store
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Taskmaster")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    // 4. Preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "Sample Task \(i)"
            newItem.completion = false
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
