//
//  Storage.swift
//  GymAi
//
//  Created by Andrew Luo on 2/13/22.
//

import Firebase
import Foundation
import SwiftUI

class Storage : ObservableObject {
  @Published var exercises : [String]
  private let db = Database.database().reference()
  
  init(){
    self.exercises = []
  }
  
  func queryExercises(session: SessionStore){
    db.child("exercises").queryOrdered(byChild:"uid").queryEqual(toValue:session.session?.uid).observe(DataEventType.value, with: { snapshot in
            for exercise in snapshot.children {
                print(exercise)              
            }
        })
  }
}
