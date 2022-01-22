//
//  GoogleSignInButton.swift
//  GymAi
//
//  Created by Andrew Luo on 1/16/22.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {
  @Environment(\.colorScheme) var colorScheme
  
  private var button = GIDSignInButton()

  func makeUIView(context: Context) -> GIDSignInButton {
    button.colorScheme = .light
    button.style = GIDSignInButtonStyle.wide
    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    button.colorScheme = .light
  }
}
