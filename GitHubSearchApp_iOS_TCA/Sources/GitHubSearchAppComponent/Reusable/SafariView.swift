//
//  SafariView.swift
//  GitHubSearchApp_iOS_TCA
//
//  Created by minii on 2023/03/16.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
  let url: URL
  
  func makeUIViewController(
    context: UIViewControllerRepresentableContext<SafariView>
  ) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }
  
  func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: UIViewControllerRepresentableContext<SafariView>
  ) {
  }
}
