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
                  
                    VStack(alignment: .center) {
//                      Text("Welcome ")
//                          .font(.headline)
//                          .foregroundColor(Color(.white))
//                    + Text(session.session?.displayName ?? "")
//                          .font(.headline)
//                          .foregroundColor(Color(.white))
                      
                      Text("Tap to tell GymAI about your workout. Our AI will understand you!")
                          .font(.custom("Nunito-Light", size: 15, relativeTo: .body))
                          .foregroundColor(Color(.white))
                          .multilineTextAlignment(.center)
                          .fixedSize(horizontal: false, vertical: true)
                          .padding(.horizontal, 10.0)
                      

                  }
                  
                }.padding()
            
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

    let s = Storage()
    @State private var text = "Tap to Start"
    @StateObject var processedString = ProcessString()



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
                .font(.custom("Nunito-Bold", size: 20, relativeTo: .body))
                .foregroundColor(Color(.white))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
              SwiftSpeech.RecordButton()
                .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                .onRecognizeLatest(update: $text)
        }.onAppear {
          SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    
   
        Button(action: {
            s.upsertData()
            processedString.inputString(inputString: text)
        })
        { Text("+ Add Set")}
            .padding()
            .foregroundColor(.white)
            .font(.custom("Nunito-Bold", size: 15, relativeTo: .body))
            .background(Color("customPink"))
            .cornerRadius(10)
    }
}
