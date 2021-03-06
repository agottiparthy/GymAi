//
//  SessionStore.swift
//  GymAi
//
//  Created by Andrew Luo on 1/16/22.
//

import SwiftUI
import AuthenticationServices
import Combine
import CryptoKit
import Firebase
import GoogleSignIn

final class SessionStore: ObservableObject {
  var didChange = PassthroughSubject<SessionStore, Never>()
  @Published var session: User? { didSet { self.didChange.send(self) }}
  var handle: AuthStateDidChangeListenerHandle?
  fileprivate var currentNonce: String?
  
  func signInGoogle() {
    if GIDSignIn.sharedInstance.hasPreviousSignIn() {
      GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
        authenticateUser(for: user, with: error)
      }
    } else {
      guard let clientID = FirebaseApp.app()?.options.clientID else { return }
      
      let configuration = GIDConfiguration(clientID: clientID)
      
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
      guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
      
      GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
        authenticateUser(for: user, with: error)
      }
    }
  }
  
  private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
    
    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
    
    Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        let givenName = user?.profile?.givenName ?? ""
        let familyName = user?.profile?.familyName ?? ""
        self.session = User(uid: (user?.userID)!, displayName: String(format: "%@ %@", givenName, familyName))
      }
    }
  }
  
  func signOut() {
    GIDSignIn.sharedInstance.signOut()
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      self.session = nil
    }
    catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
  func listen() {
    handle =  Auth.auth().addStateDidChangeListener { (auth, user) in
      if let user = user {
        self.session = User(uid: user.uid, displayName: user.displayName)
      } else {
        self.session = nil
      }
    }
  }
}
