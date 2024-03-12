//
//  LocalBackend.swift
//  FreeChat
//

import Foundation

actor LocalBackend: Backend {
  var type: BackendType = .local
  var baseURL: URL
  var apiKey: String?
  var interrupted = false
  
  init(baseURL: URL, apiKey: String?) {
    self.baseURL = baseURL
    self.apiKey = apiKey
  }

  deinit { interrupted = true }

  func listModels() async throws -> [String] {
    let req = Model.fetchRequest()
    req.sortDescriptors = [NSSortDescriptor(key: "size", ascending: true)]
    let context = PersistenceController.shared.container.newBackgroundContext()
    return try context.fetch(req).compactMap({ $0.url?.lastPathComponent })
  }
}