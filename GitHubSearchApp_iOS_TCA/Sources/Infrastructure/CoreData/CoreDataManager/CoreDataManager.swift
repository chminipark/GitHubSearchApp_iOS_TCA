//
//  CoreDataManager.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData

class CoreDataManager {
  let coreDataStorage: CoreDataStorage
  static let shared = CoreDataManager(coreDataStorage: .shared)
  
  init(coreDataStorage: CoreDataStorage) {
    self.coreDataStorage = coreDataStorage
  }
  
  func add(_ repo: Repository) async -> CoreDataError? {
    let context = coreDataStorage.mainContext
    create(repo, in: context)
    let resultError = await performContext(with: context, coreDataError: .addError)
    return resultError
  }
  
  func remove(_ repo: Repository) async -> CoreDataError? {
    let context = coreDataStorage.mainContext
    let fetchRequest: NSFetchRequest<MyRepo> = MyRepo.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "urlString == %@", repo.urlString)
    
    do {
      let objects = try context.fetch(fetchRequest)
      for object in objects {
        context.delete(object)
      }
      try context.save()
      return nil
    } catch {
      return .removeError
    }
  }
  
  fileprivate func create(_ repo: Repository, in context: NSManagedObjectContext) {
    let myRepo = MyRepo(context: context)
    myRepo.name = repo.name
    myRepo.repoDescription = repo.description
    myRepo.starCount = Int64(repo.starCount)
    myRepo.urlString = repo.urlString
  }
  
  fileprivate func performContext(with context: NSManagedObjectContext,
                                  coreDataError: CoreDataError)
  async -> CoreDataError? {
    await context.perform {
      do {
        try context.save()
        return nil
      } catch {
        return coreDataError
      }
    }
  }
}


