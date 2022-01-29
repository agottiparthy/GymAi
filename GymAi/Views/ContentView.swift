//
//  ContentView.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 1/16/22.
//

import SwiftUI
import SwiftSpeech
import Combine

struct ContentView: View {

  @EnvironmentObject private var session: SessionStore
  
  func getUser () {
    session.listen()
  }
    
  var body: some View {
    Group{
      if session.session != nil {
          HomeView()
      } else {
        LoginView()
        
      }
    }.onAppear(perform: getUser)
  }
}
