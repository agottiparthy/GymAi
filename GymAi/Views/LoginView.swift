//
//  LoginView.swift
//  GymAi
//
//  Created by Andrew Luo on 1/16/22.
//

import SwiftUI

struct LoginView: View {

  @EnvironmentObject private var session: SessionStore

  var body: some View {
    VStack {
      Spacer()

      Text("Welcome to GymAI")
        .fontWeight(.black)
        .foregroundColor(Color(.systemIndigo))
        .font(.largeTitle)
        .multilineTextAlignment(.center)

      Spacer()

      GoogleSignInButton()
        .padding()
        .onTapGesture {
          session.signIn()
        }
      
      Spacer()
    }
  }
}
