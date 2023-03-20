//
//  CoreDataManagerTests.swift
//  GitHubSearchApp_iOS_TCA_Tests
//
//  Created by minii on 2023/03/10.
//

import XCTest
import CoreData
@testable import GitHubSearchApp_iOS_TCA

final class CoreDataManagerTests: XCTestCase {
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
  
  func test_addRepo() async {
    // given
    let mockRepo = Repository.mock(1)
    
    // when
    let addError = await coreDataManager.add(mockRepo)
    
    // then
    XCTAssertNil(addError)
  }
  
  func test_removeRepo() async {
    // given
    let mockRepo = Repository.mock(2)
    
    // when
    let addError = await coreDataManager.add(mockRepo)
    let removeError = await coreDataManager.remove(mockRepo)
    
    // then
    XCTAssertNil(addError)
    XCTAssertNil(removeError)
  }
  
  func test_inCoreData() async {
    // given
    let mockRepo = Repository.mock(3)
    
    // when
    let addError = await coreDataManager.add(mockRepo)
    let inCoreData: Bool = coreDataManager.inCoreData(mockRepo)
    
    // then
    XCTAssertNil(addError)
    XCTAssertEqual(inCoreData, true)
  }
}
