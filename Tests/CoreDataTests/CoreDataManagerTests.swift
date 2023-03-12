//
//  CoreDataManagerTests.swift
//  GitHubSearchApp_iOS_TCA_Tests
//
//  Created by minii on 2023/03/10.
//

import XCTest
import CoreData
@testable import GitHubSearchApp_iOS_TCA

class CoreDataManagerTests: XCTestCase {
  var testCoreDataStorage: TestCoreDataStorage!
  var coreDataManager: CoreDataManager!
  
  override func setUp() {
    super.setUp()
    self.testCoreDataStorage = TestCoreDataStorage()
    self.coreDataManager = CoreDataManager(
      managedObjectContext: testCoreDataStorage.mainContext,
      coreDataStorage: testCoreDataStorage
    )
  }
  
  override func tearDown() {
    self.testCoreDataStorage = nil
    self.coreDataManager = nil
  }
  
  func testAddRepo() {
    // given
    let mockRepo = Repository(
      name: "repository name",
      description: "repository description",
      starCount: 100,
      urlString: "repository urlString"
    )
    
    // when
    let myRepo = coreDataManager.add(mockRepo)
    
    // then
    XCTAssertNotNil(myRepo, "myRepo should not be nil")
    XCTAssertTrue(myRepo.name == "repository name")
    XCTAssertTrue(myRepo.repoDescription == "repository description")
    XCTAssertTrue(myRepo.starCount == 100)
    XCTAssertTrue(myRepo.urlString == "repository urlString")
  }

  func testRootContextIsSavedAfterAddingRepo() {
    // given
    let mockRepo = Repository(
      name: "repository name",
      description: "repository description",
      starCount: 100,
      urlString: "repository urlString"
    )
    let derivedContext = testCoreDataStorage.newDerivedContext()
    coreDataManager = CoreDataManager(
      managedObjectContext: derivedContext,
      coreDataStorage: testCoreDataStorage
    )
    
    // when
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: testCoreDataStorage.mainContext) { _ in
      return true
    }
    
    // then
    derivedContext.perform {
      let myRepo = self.coreDataManager.add(mockRepo)
      
      XCTAssertNotNil(myRepo)
    }
    
    waitForExpectations(timeout: 2) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }
}
