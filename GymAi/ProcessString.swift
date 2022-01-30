//
//  ProcessString.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 1/16/22.
//

import Firebase
import Foundation
import SwiftUI

class ProcessString : ObservableObject {
  
    @Published var rawString: String
    @Published var parseTime: String
    @Published var parseExercise: String
    @Published var parseSets: String
    @Published var parseReps: String
    @Published var parseWeight: String
  
    private let db = Database.database().reference()
  
    init(){
        self.rawString = ""
        self.parseTime = ""
        self.parseExercise = ""
        self.parseSets = ""
        self.parseReps = ""
        self.parseWeight = ""
    }
    
    func inputString(inputString: String) {
        self.rawString = inputString
        parseString(rawString: rawString)
        printself()
        
        let uuid = UUID().uuidString

        self.db.child("exercises").child(uuid).setValue([
          "rawString": self.rawString,
          "sets": self.parseSets,
          "reps": self.parseReps,
          "weight": self.parseWeight,
          "time": self.parseTime,
          "name": self.parseExercise
        ])
    }
    
    func printself() {
        print(rawString)
        print("Exercise: \(parseExercise)")
        print("Sets: \(parseSets)")
        print("Weight: \(parseWeight)")
        print("Reps: \(parseReps)")
        print("Time: \(parseTime)")
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

        return String(newArray).lowercased()
    }
    

    func removeWordNumbers(charArray: [String]) -> [String]{
        var newArray = charArray
        var i = 0
        
        while i < charArray.count {
            if charArray[i] == "nine" {
                newArray[i] = "9"
            } else if charArray[i] == "eight" {
                newArray[i] = "8"
            } else if charArray[i] == "seven" {
                newArray[i] = "7"
            } else if charArray[i] == "six" {
                newArray[i] = "6"
            } else if charArray[i] == "five" {
                newArray[i] = "5"
            } else if charArray[i] == "four" {
                newArray[i] = "4"
            } else if charArray[i] == "three" {
                newArray[i] = "3"
            } else if charArray[i] == "two" {
                newArray[i] = "2"
            } else if charArray[i] == "one" {
                newArray[i] = "1"
            } else if charArray[i] == "hundred" {
                newArray[i] = "100"
            }
            i += 1
        }
        return newArray
            
    }
  
    func parseString(rawString: String) -> () {
        let cleanedString = cleanString(text: self.rawString)
        var textArr = cleanedString.components(separatedBy: " ")
        textArr = removeWordNumbers(charArray: textArr)


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
        } else {
            parseTime = "0"
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
        } else {
            parseWeight = ""
        }

        //remove all used words maintaining array order. Stripping is only way I can think off to find the exercise name
        let sorted = releventIndices.sorted()
        let reversed: [Int] = Array(sorted.reversed())

        for i in reversed {
            strippedString.remove(at: i)
        }

        let prepositions: Set<String> = ["i", "for", "and", "to", "me", "did", "lifted", "to", "with", "of", "on", "the"]
        strippedString.removeAll(where: {prepositions.contains($0)})
        parseExercise = strippedString.joined(separator: " ")

        print(parseExercise)

        return
    }
  
  //parseString helpers. CAPITALIZE KEY WORDS, matching is case sensititve.
    func containedReps(textArr:[String]) -> Int {
        let keywords = ["reps", "wraps", "repetitions", "times", "repetition"]

        for keyword in keywords {
          let index = textArr.firstIndex(of: keyword)
          if index != nil {
            return index! - 1
          }
        }
        return -1
    }

    func containedTime(textArr:[String]) -> Int {
        let keywords =  ["seconds", "minutes", "hours", "secs", "mins", "sex"]

        for keyword in keywords {
          let index = textArr.firstIndex(of: keyword)
          if index != nil {
            return index! - 1
          }
        }
        return -1
    }

    func containedSets(textArr:[String]) -> Int {
        let keywords =  ["sets", "set"]

        for keyword in keywords {
          let index = textArr.firstIndex(of: keyword)
          if index != nil {
            return index! - 1
          }
        }
        return -1
    }

    func containedWeight(textArr:[String]) -> Int {
        let keywords = ["pounds", "kg\'s", "kilograms", "lb\'s", "plates"]

        for keyword in keywords {
          let index = textArr.firstIndex(of: keyword)
          if index != nil {
            return index! - 1
          }
        }
        return -1
    }
  
  
}


