//
//  LoginView.swift
//  GymAi
//
//  Created by Andrew Luo on 1/16/22.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct LoginView: View {
  
  @EnvironmentObject private var session: SessionStore
  @State var currentNonce:String?
  
  //Hashing function using CryptoKit
  func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
  
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }
      
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    
    return result
  }
  
  var body: some View {
    ZStack{
      
      RadialGradient(gradient: Gradient(colors: [Color("GradientCenter"), Color("GradientEdge")]), center: .center, startRadius: 2, endRadius: 650).ignoresSafeArea()
      VStack(spacing: 20) {
        Spacer()          
          
          Image("Logos").padding(.bottom)
          
          Text("GymAI")
              .font(.custom("Roboto", size: 50, relativeTo: .body))
              .foregroundColor(Color(red: 0.6196078431372549, green: 0.8156862745098039, blue: 0.9019607843137255))
          .multilineTextAlignment(.center)
          .padding(.bottom)
          
          Text("AI Powered Workout Journal")
              .font(.custom("Roboto-Light", size: 30, relativeTo: .body))
            .foregroundColor(Color(.white))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom)
    
        
        GoogleSignInButton()
              .padding([.leading, .bottom])
              .frame(width: 280, height: 45, alignment: .center)
          .cornerRadius(8.0)
          .onTapGesture {
            session.signInGoogle()
          }
        
        SignInWithAppleButton(
          //Request
          onRequest: { request in
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
          },
          
          //Completion
          onCompletion: { result in
            switch result {
            case .success(let authResults):
              switch authResults.credential {
              case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                guard let nonce = currentNonce else {
                  fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                  fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                  print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                  return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                  if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                  }
                  print("signed in")
                }
                
                print("\(String(describing: Auth.auth().currentUser?.uid))")
              default:
                break
                
              }
            default:
              break
            }
            
          }
        )
              .padding(.bottom)
              .frame(width: 280, height: 45, alignment: .center)
        .signInWithAppleButtonStyle(.white)
      }
    }
    .preferredColorScheme(.dark)
  }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
