//
//  Storage.swift
//  GymAi
//
//  Created by Andrew Luo on 1/20/22.
//

import Foundation
import Firebase

class Storage {
  private let db = Database.database().reference()
  
  func upsertData(){
    print("upserting data")
    self.db.child("exercises").child("exercise-id-1").setValue([
      "rawString": "raw data string",
      "reps": 5,
      "weight": 100,
    ])
  }
  
}
