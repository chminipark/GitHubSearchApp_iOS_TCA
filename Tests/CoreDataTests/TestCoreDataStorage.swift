//
//  TestCoreDataStorage.swift
//  GitHubSearchApp_iOS_TCA_Tests
//
//  Created by minii on 2023/03/12.
//

import CoreData
@testable import GitHubSearchApp_iOS_TCA

class TestCoreDataStorage: CoreDataStorage {
  override init() {
    super.init()
    
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType
    
    let container = NSPersistentContainer(
      name: CoreDataStorage.modelName,
      managedObjectModel: CoreDataStorage.model
    )
    
    container.persistentStoreDescriptions = [persistentStoreDescription]
    
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    storeContainer = container
  }
}
