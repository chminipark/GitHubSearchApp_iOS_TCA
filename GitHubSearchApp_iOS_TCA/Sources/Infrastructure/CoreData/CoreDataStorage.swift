//
//  CoreDataStorage.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData

enum StoreType {
  case persistent, inMemory
  
  func NSStoreType() -> String {
    switch self {
    case .persistent:
      return NSSQLiteStoreType
    case .inMemory:
      return NSInMemoryStoreType
    }
  }
}

class CoreDataStorage {
  let storeType: StoreType
  
  static let shared = CoreDataStorage(storeType: .persistent)
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MyRepo")
    
    if self.storeType == .inMemory {
      let description = NSPersistentStoreDescription()
      description.type = self.storeType.NSStoreType()
      container.persistentStoreDescriptions = [description]
    }
    
    container.loadPersistentStores { _, error in
      if let error = error as? NSError {
        fatalError("😡😡😡😡😡 Unable to load coredata persistent stores: \(error)")
      }
    }
    
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // merge 충돌시 in-memory 우선
    container.viewContext.shouldDeleteInaccessibleFaults = true // 접근 불가 결함 삭제 가능하게 설정
    container.viewContext.automaticallyMergesChangesFromParent = true // parent context가 바뀌면 자동 merge
    
    return container
  }()
  
  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  init(storeType: StoreType) {
    self.storeType = storeType
  }
  
  fileprivate func setBackgroundContext(_ context: NSManagedObjectContext) {
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    context.undoManager = nil // 실행취소 비활성화
  }
  
  func taskContext() -> NSManagedObjectContext {
    let taskContext = persistentContainer.newBackgroundContext()
    setBackgroundContext(taskContext)
    return taskContext
  }
  
  func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
    persistentContainer.performBackgroundTask { context in
      self.setBackgroundContext(context)
      task(context)
    }
  }
}
