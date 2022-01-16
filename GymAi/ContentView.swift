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
    
    
    var body: some View {
       
        VStack {
            Basic.init()
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Basic : View {
    
    var sessionConfiguration: SwiftSpeech.Session.Configuration
    
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
                ProcessString(rawString: text).printString()
            }
        }.onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}
