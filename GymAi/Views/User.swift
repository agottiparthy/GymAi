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
  
  init(uid: String, displayName: String?) {
    self.uid = uid
    self.displayName = displayName
  }
}
