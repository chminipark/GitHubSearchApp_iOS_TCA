//
//  MyRepo+CoreDataProperties.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/10.
//
//

import Foundation
import CoreData

extension MyRepo {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MyRepo> {
    return NSFetchRequest<MyRepo>(entityName: "MyRepo")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var repoDescription: String?
  @NSManaged public var starCount: Int64
  @NSManaged public var urlString: String?
}

extension MyRepo : Identifiable {}

extension MyRepo {
  func toDomain() -> Repository? {
    guard let name = name,
          let description = repoDescription,
          let urlString = urlString
    else {
      return nil
    }
    let starCount = Int(starCount)
    
    return Repository(name: name,
                      description: description,
                      starCount: starCount,
                      urlString: urlString)
  }
}
