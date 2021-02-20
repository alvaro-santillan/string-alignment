//
//  main.swift
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

// Known bug: word prossessing section is missing a edge case. Look into minRepeat.
// Failed: "A","C","G","T","C","A","T","C","A". insertCost = 1 deleteCost = 1 subCost = 2 minRepeat = 1
import Foundation




func stringFormater(startString: String) -> [String] {
    var upperCasedStartString = Array(startString.uppercased())
    upperCasedStartString.insert("-", at: upperCasedStartString.startIndex)
    
    var startStringArray = [String]()
    for letter in upperCasedStartString {
        startStringArray.append(String(letter))
    }
    
    return startStringArray
}

let startString = "Bear"
let endString = ["-","B","E","A","R"]
print(stringFormater(startString: startString))
