//
//  ProfileView.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 2/3/22.
//

import SwiftUI

struct ProfileView: View {
  
  @EnvironmentObject private var session: SessionStore
  @State var changeProfileImage = false
  @State var openCameraRoll = false
  @State var imageSelected = UIImage()
  
  var body: some View {
    VStack {
      HStack {
        HStack{
          Text("Hello, ")
            .font(.system(size: 20))
          + Text(session.session?.displayName ?? "")
            .font(.system(size: 20))
        }.padding()
        
        Spacer()
        
        AsyncImage(url: session.session?.profileURL){ phase in
          switch phase {
          case .empty:
            ProgressView()
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
              .frame(width: 40, height: 40)
              .clipShape(Circle())
          case .failure:
            Image(systemName: "person.circle.fill")
          @unknown default:
            // Since the AsyncImagePhase enum isn't frozen,
            // we need to add this currently unused fallback
            // to handle any new cases that might be added
            // in the future:
            EmptyView()
          }
        }
        
//        Button(action: {
//          changeProfileImage = true
//          openCameraRoll = true
//
//        }, label: {
//          if changeProfileImage {
//            Image(uiImage: imageSelected)
//              .frame(width: 50, height: 50)
//              .clipShape(Circle())
//          }
//
//          Image(systemName: "person.crop.circle.fill.badge.plus")
//            .font(.system(size: 50))
//            .foregroundColor(Color(.white))
//            .padding()
//
//        })
//      }.sheet(isPresented: $openCameraRoll) {
//        ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
//      }
      Spacer()
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
