//
//  HomeView.swift
//  GymAi
//
//  Created by Andrew Luo on 1/16/22.
//

import Combine
import GoogleSignIn
import SwiftUI
import SwiftSpeech

struct HomeView: View {
  
  @EnvironmentObject private var session: SessionStore
  
  var body: some View {
    ZStack{
      
      RadialGradient(gradient: Gradient(colors: [Color("GradientCenter"), Color("GradientEdge")]), center: .center, startRadius: 2, endRadius: 650).ignoresSafeArea()
      VStack {
        HStack {
          
          VStack(alignment: .leading) {
            Text("Welcome ")
              .font(.headline)
              .foregroundColor(Color(.white))
            + Text(session.session?.displayName ?? "")
              .font(.headline)
              .foregroundColor(Color(.white))
          }
          
        }
        Spacer()
        
        Basic.init()
        
        Button(action: session.signOut) {
          Text("Sign out")
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemIndigo))
            .cornerRadius(12)
            .padding()
        }
      }
    }
    .preferredColorScheme(.dark)
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


struct Basic : View {
  
  var sessionConfiguration: SwiftSpeech.Session.Configuration
  let contextStrings: [String] = ["squat", "squatted", "reps", "bench press", "squats"]
  
  let s = Storage()
  @State private var text = "Tap to Speak"
  
  
  public init(sessionConfiguration: SwiftSpeech.Session.Configuration) {
    self.sessionConfiguration = sessionConfiguration
  }
  
  public init(locale: Locale = .current) {
    self.init(sessionConfiguration: SwiftSpeech.Session.Configuration(locale: locale))
  }
  
  public init(localeIdentifier: String) {
    self.init(locale: Locale(identifier: localeIdentifier))
  }
  
  public var body: some View {
    VStack(spacing: 35.0) {
      Text(text)
        .font(.system(size: 25, weight: .bold, design: .default))
      SwiftSpeech.RecordButton()
        .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .onRecognizeLatest(update: $text)
      Button("Save") {
        s.upsertData()
        ProcessString(rawString: text)
      }
    }.onAppear {
      SwiftSpeech.requestSpeechRecognitionAuthorization()
    }
  }
}
