//
//  ProcessString.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 1/16/22.
//

import Firebase
import Foundation
import SwiftUI

struct ProcessString {
  
  var rawString: String
  var parseTime: String
  var parseExercise: String
  var parseSets: String
  var parseReps: String
  var parseWeight: String
  
  private let db = Database.database().reference()
  
  init(rawString: String){
    self.rawString = rawString
    self.parseTime = ""
    self.parseExercise = ""
    self.parseSets = ""
    self.parseReps = ""
    self.parseWeight = ""
    
    let cleanedString = cleanString(text: self.rawString)
    let splitString = cleanedString.components(separatedBy: " ")
    
    parseString(textArr: splitString)
    
    let uuid = UUID().uuidString
    let sets = Int(self.parseSets)
    let reps = Int(self.parseReps)
    let weight = Double(self.parseWeight)
    let time = Double(self.parseTime)
    self.db.child("exercises").child(uuid).setValue([
      "rawString": self.rawString,
      "sets": sets ?? 0,
      "reps": reps ?? 0,
      "weight": weight ?? 0.0,
      "time": time ?? 0.0,
      "name": self.parseExercise
    ])
    
    print(splitString)
    
  }
  
  func cleanString(text: String) -> String {
    let charArray = Array(text)
    var newArray = charArray
    var i = 0
    while i < charArray.count {
      if charArray[i] == "." {
        newArray.remove(at: i)
      }
      
      
      i += 1
    }
    
    return String(newArray).capitalized
  }
  
  mutating func parseString(textArr: [String]) -> () {
    var strippedString = textArr
    var releventIndices:[Int] = []
    
    let repIndex = containedReps(textArr: textArr)
    if repIndex != -1 {
      parseReps = textArr[repIndex] + " " + textArr[repIndex + 1]
      releventIndices.append(repIndex)
      releventIndices.append(repIndex + 1)
      
    }
    
    let timeIndex = containedTime(textArr: textArr)
    if timeIndex != -1 {
      parseTime = textArr[timeIndex] + " " + textArr[timeIndex + 1]
      releventIndices.append(timeIndex)
      releventIndices.append(timeIndex + 1)
    }
    
    let setIndex = containedSets(textArr: textArr)
    if setIndex != -1 {
      parseSets = textArr[setIndex] + " " + textArr[setIndex + 1]
      releventIndices.append(setIndex)
      releventIndices.append(setIndex + 1)
    } else {
      parseSets = "1 Set"
    }
    
    
    let weightIndex = containedWeight(textArr: textArr)
    if weightIndex != -1 {
      parseWeight = textArr[weightIndex] + " " + textArr[weightIndex + 1]
      releventIndices.append(weightIndex)
      releventIndices.append(weightIndex + 1)
    }
    
    //remove all used words maintaining array order. Stripping is only way I can think off to find the exercise name
    let sorted = releventIndices.sorted()
    let reversed: [Int] = Array(sorted.reversed())
    
    for i in reversed {
      strippedString.remove(at: i)
    }
    
    let prepositions: Set<String> = ["I", "For", "And", "To", "Me", "Did", "Lifted", "To", "With", "Of"]
    strippedString.removeAll(where: {prepositions.contains($0)})
    parseExercise = strippedString.joined(separator: " ")
    
    print(parseExercise)
    
    return
  }
  
  //parseString helpers. CAPITALIZE KEY WORDS, matching is case sensititve.
  func containedReps(textArr:[String]) -> Int {
    let keywords = ["Reps", "Wraps", "Repetitions", "Times", "Repetition"]
    
    for keyword in keywords {
      let index = textArr.firstIndex(of: keyword)
      if index != nil {
        return index! - 1
      }
    }
    return -1
  }
  
  func containedTime(textArr:[String]) -> Int {
    let keywords = ["Seconds", "Minutes", "Hours", "Sex", "Mins", "Sex"]
    
    for keyword in keywords {
      let index = textArr.firstIndex(of: keyword)
      if index != nil {
        return index! - 1
      }
    }
    return -1
  }
  
  func containedSets(textArr:[String]) -> Int {
    let keywords = ["Sets", "Set"]
    
    for keyword in keywords {
      let index = textArr.firstIndex(of: keyword)
      if index != nil {
        return index! - 1
      }
    }
    return -1
  }
  
  func containedWeight(textArr:[String]) -> Int {
    let keywords = ["Pounds", "Kg\'s", "Kilograms", "Lb\'s", "Plates"]
    
    for keyword in keywords {
      let index = textArr.firstIndex(of: keyword)
      if index != nil {
        return index! - 1
      }
    }
    return -1
  }
  
  
}


