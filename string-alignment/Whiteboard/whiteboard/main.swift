//
//  main.swift
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

// Known bug: word prossessing section is missing a edge case. Look into minRepeat.
// Failed: "A","C","G","T","C","A","T","C","A". insertCost = 1 deleteCost = 1 subCost = 2 minRepeat = 1
import Foundation

let topPlusCost = 1
let leftPlusCost = 1
let diagonal = 0

let theMin = min(topPlusCost, leftPlusCost, diagonal)

if theMin == topPlusCost {
    print("a")
} else if theMin == leftPlusCost {
    print("b")
} else {
    print("c")
}
