//
//  CoreDataManager.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData

final class CoreDataManager {
  let managedObjectContext: NSManagedObjectContext
  let coreDataStorage: CoreDataStorage
  
  init(managedObjectContext: NSManagedObjectContext, coreDataStorage: CoreDataStorage) {
    self.managedObjectContext = managedObjectContext
    self.coreDataStorage = coreDataStorage
  }
  
  func add(_ repo: Repository) -> MyRepo {
    let myRepo = MyRepo(context: managedObjectContext)
    myRepo.name = repo.name
    myRepo.repoDescription = repo.description
    myRepo.urlString = repo.urlString
    myRepo.starCount = Int64(repo.starCount)
    
    coreDataStorage.saveContext(managedObjectContext)
    
    return myRepo
  }
}

extension CoreDataManager {
  static let shared: CoreDataManager = {
    let coreDataStorage = CoreDataStorage.shared
    let coreDataManager = CoreDataManager(
      managedObjectContext: coreDataStorage.mainContext,
      coreDataStorage: coreDataStorage
    )
    
    return coreDataManager
  }()
}
