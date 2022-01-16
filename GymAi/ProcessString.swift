//
//  ProcessString.swift
//  GymAi
//
//  Created by Ani Gottiparthy on 1/16/22.
//

import Foundation
import SwiftUI

struct ProcessString {
    var rawString: String
    
    
    func printString() {
        
        var cleanedString = cleanString(text: self.rawString)
        
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
        
        return String(newArray)
    }
    
    func parseString(text: String) -> (repBegin: Int, repEnd: Int) {
//        let detectedReps = textArr.firstIndex(of: "Reps")
//        let detectedWraps = textArr.firstIndex(of: "Wraps")
//        let detectedRepetitions = textArr.firstIndex(of: "Repetitions")
//        let detectedRepetition = textArr.firstIndex(of: "Repetition")

        return (0, 0)
    }
    
}


