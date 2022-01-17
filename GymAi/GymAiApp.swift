//
//  GymAiApp.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 1/16/22.
//

import Firebase
import SwiftUI
import SwiftSpeech
import Speech

@main
struct GymAiApp: App {
  
  @StateObject var session = SessionStore()

  init() {
   FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(session)
    }
  }
}




