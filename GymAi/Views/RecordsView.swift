//
//  RecordsView.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 2/3/22.
//

import Firebase
import SwiftUI

struct RecordsView: View {
  @EnvironmentObject private var session: SessionStore
  private let db = Database.database().reference()
  @StateObject private var storage = Storage()
  
  var body: some View {
    ZStack {
//      if let exercises = storage.exercises {
//        Text(exercises[0])
//      }
    }.onAppear{
      storage.queryExercises(session: session)
    }
  }
}

struct RecordsView_Previews: PreviewProvider {
  static var previews: some View {
    RecordsView()
  }
}
