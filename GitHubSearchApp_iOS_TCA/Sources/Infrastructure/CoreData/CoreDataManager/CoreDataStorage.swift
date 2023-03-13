//
//  CoreDataStorage.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData

class CoreDataStorage {
  static let shared = CoreDataStorage()
  
  static let modelName = "MyRepo"
  
  static let model: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: CoreDataStorage.modelName,
                                          managedObjectModel: CoreDataStorage.model)
    
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    return container
  }()
  
  var mainContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func backgroundContext() -> NSManagedObjectContext {
    let context = persistentContainer.newBackgroundContext()
    return context
  }
}
