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
      TabView {
          VStack {
              HStack {
                  Spacer()
                  Button(action: session.signOut) {
                    Text("Sign out")
                          .padding(.trailing, 10.0)
                          .foregroundColor(.blue)
                          .cornerRadius(12)
                  }
              }

                    
            HStack {
                  Text("Welcome ")
                      .font(.headline)
                      .foregroundColor(Color(.white))
                    + Text(session.session?.displayName ?? "")
                      .font(.headline)
                      .foregroundColor(Color(.white))
              }.padding()

            Text("Tap to tell GymAI about your workout. Our AI will understand you!")
                  .font(.custom("Nunito-Light", size: 15, relativeTo: .body))
                  .foregroundColor(Color(.white))
                  .multilineTextAlignment(.center)
                  .fixedSize(horizontal: false, vertical: true)
                  .padding(.all, 10.0)

              Basic.init()
                  .padding(.top, 20.0)
            
              Spacer()
              
              
          }.preferredColorScheme(.dark).padding(.top, 10.0)
              .tabItem {
                  Image(systemName: "house.fill")
                  Text("Home")
              }
          
          RecordsView()
              .tabItem{
                  Image(systemName: "chart.bar.doc.horizontal")
                  Text("Records")
              }
          
          ProfileView()
              .tabItem {
                  Image(systemName: "person.circle.fill")
                  Text("Profile")
              }
      }
      

  }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Basic : View {
    @EnvironmentObject private var UserSession: SessionStore
    
    private var sessionConfiguration: SwiftSpeech.Session.Configuration
    @StateObject private var processedString = ProcessString()
    
    @State private var text = "Tap to Start"
    
    @State private var inputExercise = ""
    @State private var inputTime = ""
    @State private var inputReps = ""
    @State private var inputSets = ""
    @State private var inputWeight = ""
    
    @State private var uploadSuccess = ""
    

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
                .onStartRecording(appendAction: { session in
                    uploadSuccess = ""
                })
                .onStopRecording { session in
                    processedString.inputString(inputString: text, session: UserSession)
                    inputExercise = processedString.parseExercise
                    inputTime = processedString.parseTime
                    inputReps = processedString.parseReps
                    inputWeight = processedString.parseWeight
                    inputSets = processedString.parseSets
                }
            
            
            HStack {
                Text(uploadSuccess).foregroundColor(.green)
                
                Spacer()
                
                Button(action: {
                    processedString.updateInputs(newTime: inputTime, newExercise: inputExercise, newSets: inputSets, newReps: inputReps, newWeight: inputWeight)
                    if processedString.uploadString(inputString: text, session: UserSession) {
                        
                        uploadSuccess = "Upload Succeeded!"
                        
                        
                    }
                })
                { Text("+ Add Set")}
                .padding(.all, 10.0)
                    .foregroundColor(.white)
                    .font(.custom("Nunito-Bold", size: 15, relativeTo: .body))
                    .background(Color("customPink"))
                    .cornerRadius(10)
            }
        
            
            TextField("Exercise",text:$inputExercise).foregroundColor(.white)
            TextField("Weight", text: $inputWeight).foregroundColor(.white)
            TextField("Reptitions", text:$inputReps).foregroundColor(.white)
            TextField("Sets", text: $inputSets).foregroundColor(.white)


            
            
        }.onAppear {
          SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}
