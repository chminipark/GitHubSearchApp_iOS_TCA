//
//  CoreDataManager.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData
import ComposableArchitecture

class CoreDataManager {
  let coreDataStorage: CoreDataStorage
  static let shared = CoreDataManager(coreDataStorage: .shared)
  
  init(coreDataStorage: CoreDataStorage) {
    self.coreDataStorage = coreDataStorage
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
  
  func fetch(_ repo: Repository, context: NSManagedObjectContext) -> MyRepo? {
    let fetchRequest: NSFetchRequest<MyRepo> = MyRepo.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "urlString == %@", repo.urlString)
    
    do {
      return try context.fetch(fetchRequest).first
    } catch {
      return nil
    }
  }
}

extension CoreDataManager {
  func add(_ repo: Repository) async -> CoreDataError? {
    let context = coreDataStorage.mainContext
    if let savedRepo = fetch(repo, context: context) {
      return nil
    }
    
    create(repo, in: context)
    let addError = await performContext(with: context, coreDataError: .addError)
    return addError
  }
  
  func remove(_ repo: Repository) async -> CoreDataError? {
    let context = coreDataStorage.mainContext
    do {
      guard let object = fetch(repo, context: context) else {
        return nil
      }
      context.delete(object)
      try context.save()
      return nil
    } catch {
      return .removeError
    }
  }
  
  func inCoreData(_ repo: Repository) -> Bool {
    let context = coreDataStorage.mainContext
    if let savedRepo = fetch(repo, context: context) {
      return true
    } else {
      return false
    }
  }
}
