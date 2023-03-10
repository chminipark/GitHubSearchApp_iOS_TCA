//
//  GitHubSearchApp_iOS_TCAApp.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/02/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct GitHubSearchApp_iOS_TCAApp: App {
  
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
