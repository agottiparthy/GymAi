//
//  User.swift
//  GymAi
//
//  Created by Andrew Luo on 1/16/22.
//

import Foundation

class User {
  var uid: String
  var displayName: String?
  var profileURL: URL?
  
  init(uid: String, displayName: String?, profileURL: URL?) {
    self.uid = uid
    self.displayName = displayName
    self.profileURL = profileURL
  }
}
