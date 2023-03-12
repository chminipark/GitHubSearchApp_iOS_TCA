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
  
//  XCTAssertNotNil(report, "Report should not be nil")
//  XCTAssertTrue(report.location == "Death Star")
//  XCTAssertTrue(report.numberTested == 1000)
//  XCTAssertTrue(report.numberPositive == 999)
//  XCTAssertTrue(report.numberNegative == 1)
//  XCTAssertNotNil(report.id, "id should not be nil")
//  XCTAssertNotNil(report.dateReported, "dateReported should not be nil")
  
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
}
