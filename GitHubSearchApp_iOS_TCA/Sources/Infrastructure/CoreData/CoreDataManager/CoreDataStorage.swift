//
//  CoreDataStorage.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData

class CoreDataStorage {
  static let modelName = "MyRepo"
  
  static let model: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: CoreDataStorage.modelName,
                                          managedObjectModel: CoreDataStorage.model)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  lazy var mainContext: NSManagedObjectContext = {
    return storeContainer.viewContext
  }()
  
  func newDerivedContext() -> NSManagedObjectContext {
    let context = storeContainer.newBackgroundContext()
    return context
  }
  
  func saveContext() {
    saveContext(mainContext)
  }
  
  func saveContext(_ context: NSManagedObjectContext) {
    if context != mainContext {
      saveDerivedContext(context)
      return
    }
    
    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  func saveDerivedContext(_ context: NSManagedObjectContext) {
    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      
      self.saveContext(self.mainContext)
    }
  }
}

extension CoreDataStorage {
  static let shared = CoreDataStorage()
}
