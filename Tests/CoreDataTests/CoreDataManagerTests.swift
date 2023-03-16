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
  var coreDataStorage: TestCoreDataStorage!
  var coreDataManager: CoreDataManager!
  
  override func setUp() {
    super.setUp()
    self.coreDataStorage = TestCoreDataStorage()
    self.coreDataManager = CoreDataManager(coreDataStorage: coreDataStorage)
  }
  
  override func tearDown() {
    self.coreDataStorage = nil
    self.coreDataManager = nil
  }
  
  func testAddRepo() async {
    // given
    let mockRepo = Repository.mock(1)
    
    // when
    let addError = await coreDataManager.add(mockRepo)
    
    // then
    XCTAssertNil(addError)
  }
  
  func testRemoveRepo() async {
    // given
    let mockRepo = Repository.mock(2)
    
    // when
    let addError = await coreDataManager.add(mockRepo)
    let removeError = await coreDataManager.remove(mockRepo)
    
    // then
    XCTAssertNil(addError)
    XCTAssertNil(removeError)
  }
  
  func testInCoreData() async {
    // given
    let mockRepo = Repository.mock(3)
    
    // when
    let addError = await coreDataManager.add(mockRepo)
    XCTAssertNil(addError)
    
    // then
    let inCoreData: Bool = coreDataManager.inCoreData(mockRepo)
    XCTAssertEqual(inCoreData, true)
  }
}
