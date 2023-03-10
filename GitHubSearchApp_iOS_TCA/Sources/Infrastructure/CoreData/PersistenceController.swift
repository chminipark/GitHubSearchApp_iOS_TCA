//
//  CoreDataManager.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//

//import Foundation
import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let myContainer = "myContainer"
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: myContainer)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  func saveContext() {
    let context = container.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}


