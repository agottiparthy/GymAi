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
                Text("Hello, User")
                    .padding()
                    .font(.system(size: 20))
                
                Spacer()
                
                Button(action: {
                    changeProfileImage = true
                    openCameraRoll = true
                    
                }, label: {
                    if changeProfileImage {
                        Image(uiImage: imageSelected)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(.system(size: 50))
                        .foregroundColor(Color(.white))
                        .padding()

                })
            }.sheet(isPresented: $openCameraRoll) {
                ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
            }
            
            Spacer()
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
