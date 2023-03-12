//
//  CoreDataManager.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

import CoreData

class CoreDataManager {
  let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
  
  func add(repo: Repository) {
    let context = coreDataStorage.taskContext()
    if fetch(repo.id, in: context) != nil {
      create(repo, in: context)
    }
    
    context.performAndWait {
      do {
        try context.save()
      } catch {
        print(error)
      }
    }
  }
  
  func create(_ repo: Repository, in context: NSManagedObjectContext) {
    let item = MyRepo(context: context)
    item.name = repo.name
    item.repoDescription = repo.description
    item.starCount = Int64(repo.starCount)
    item.urlString = repo.urlString
  }
  
  func fetch(_ id: String, in context: NSManagedObjectContext) -> MyRepo? {
    let fetchRequest = MyRepo.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "urlString == %@", [id])
    do {
      return try context.fetch(fetchRequest).first
    } catch {
      print("😡😡😡😡😡 fetch MyRepo error : \(error)")
      return nil
    }
  }
  
  func fetchAll() -> [MyRepo] {
    let request = MyRepo.fetchRequest()
    do {
      return try coreDataStorage.viewContext.fetch(request)
    } catch {
      print("😡😡😡😡😡 fetchAll MyRepo error : \(error)")
      return []
    }
  }
}
