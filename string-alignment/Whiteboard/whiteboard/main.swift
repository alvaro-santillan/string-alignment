//
//  main.swift
//  sdfg
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

func alignStrings(newStartString: [String], newEndString: [String], insertCost: Int, deleteCost: Int, subCost: Int) -> [[Int]] {
    // Modify the strings and create a matrix of the corret size with np.inf for every cell.
//    let startString = "-" + startString
//    let endString = "-" + endString
//    let newEndString = endString.components(separatedBy: "")
//    let newStartString = endString.components(separatedBy: "")
    
    var costMatrix = [[Int]]()
    
    for x in 0...newStartString.count - 1 {
        var tempArray = [Int]()
        for y in 0...newEndString.count - 1 {
            tempArray.append(Int.max-2)
        }
        costMatrix.append(tempArray)
    }

    // For loop to update matrix to correct values.
    for y in 0...newStartString.count - 1 {
//        print("yy" + String(y))
        for x in 0...newEndString.count - 1 {
            var diagonal = Int.max-2
            var topPlusCost = Int.max-2
            var leftPlusCost = Int.max-2
            var diagonalPlusCost = Int.max-2
            
            if (y-1 > -1) && (x-1 > -1) {
                diagonal = costMatrix[y-1][x-1]
            }
            
            if (y-1 > -1) {
                diagonalPlusCost = diagonal + subCost
            }
            
            if (y-1 > -1) {
                topPlusCost = costMatrix[y-1][x] + deleteCost
            }
            
            if (x-1 > -1) {
                leftPlusCost = costMatrix[y][x-1] + insertCost
            }
            else {
//                print(x,y)
                leftPlusCost = 1
            }
//            print(diagonal,topPlusCost,leftPlusCost,diagonalPlusCost)
//            print("---")
            
            // Populate first spot with 0 runs once.
            if newEndString[x] == "-" && newStartString[y] == "-" {
                costMatrix[y][x] = 0
//                print("a", costMatrix[y][x])
            // Populate the first x and y columns in the matrix.
            }
            else if newEndString[x] == "-" {
                costMatrix[y][x] = y * deleteCost
//                print("b", costMatrix[y][x])
            }
            else if newEndString == ["-"] {
                costMatrix[y][x] = y * insertCost
            // Append the smallest value while taking into consideration if the diagonal is a no-op or a sub.
            }
            else if newEndString[x] == newStartString[y] {
                costMatrix[y][x] = min(topPlusCost, leftPlusCost, diagonal)
//                print("c", costMatrix[y][x], topPlusCost, leftPlusCost, diagonal)
            }
            else {
                costMatrix[y][x] = min(topPlusCost, leftPlusCost, diagonalPlusCost)
//                print("d", costMatrix[y][x], topPlusCost, leftPlusCost, diagonalPlusCost)
            }
        }
    }

    
//    for i in costMatrix {
//        print(i)
//    }
//    print(costMatrix)
    return costMatrix
}

var py = [[0, 1, 2, 3, 4], [1, 0, 1, 2, 3], [2, 1, 2, 3, 2], [3, 2, 1, 2, 3], [4, 3, 2, 1, 2]]

py = [[0, 1, 2, 3, 4, 5], [1, 0, 1, 2, 3, 4], [2, 1, 0, 1, 2, 3], [3, 2, 1, 0, 1, 2], [4, 3, 2, 1, 2, 3], [5, 4, 3, 2, 1, 2]]

py = [[0, 1, 2, 3, 4, 5, 6], [1, 0, 1, 2, 3, 4, 5], [2, 1, 0, 1, 2, 3, 4], [3, 2, 1, 0, 1, 2, 3], [4, 3, 2, 1, 2, 3, 4], [5, 4, 3, 2, 3, 4, 3]]

py = [[0, 1, 2, 3, 4, 5, 6, 7], [1, 2, 3, 4, 5, 4, 5, 6], [2, 1, 2, 3, 4, 5, 6, 7], [3, 2, 3, 2, 3, 4, 5, 6], [4, 3, 2, 3, 4, 5, 6, 7], [5, 4, 3, 4, 3, 4, 5, 6], [6, 5, 4, 5, 4, 5, 6, 7], [7, 6, 5, 6, 5, 6, 7, 8], [8, 7, 6, 7, 6, 7, 8, 7], [9, 8, 7, 8, 7, 8, 7, 8]]
py = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], [3, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [4, 3, 2, 3, 4, 5, 6, 7, 8, 9, 10], [5, 4, 3, 4, 5, 4, 5, 6, 7, 8, 9], [6, 5, 4, 5, 6, 5, 6, 7, 8, 9, 10], [7, 6, 5, 6, 7, 6, 7, 8, 9, 10, 11], [8, 7, 6, 7, 8, 7, 8, 9, 10, 11, 12], [9, 8, 7, 8, 9, 8, 9, 10, 9, 10, 11], [10, 9, 8, 9, 10, 9, 10, 11, 10, 9, 10], [11, 10, 9, 8, 9, 10, 11, 12, 11, 10, 9]]
py = [[0, 1, 2, 3, 4, 5, 6, 7, 8], [1, 2, 1, 2, 3, 4, 5, 6, 7], [2, 3, 2, 3, 4, 5, 6, 5, 6], [3, 4, 3, 2, 3, 4, 5, 6, 7], [4, 3, 4, 3, 2, 3, 4, 5, 6], [5, 4, 5, 4, 3, 4, 5, 4, 5], [6, 5, 4, 5, 4, 5, 6, 5, 4], [7, 6, 5, 6, 5, 6, 5, 6, 5], [8, 7, 6, 7, 6, 7, 6, 5, 6], [9, 8, 7, 8, 7, 8, 7, 6, 5]]
//let sw = alignStrings(newStartString: ["-","B","E","A","R"], newEndString: ["-","B","A","R","E"], insertCost: 1, deleteCost: 1, subCost: 2)
//let sw = alignStrings(newStartString: ["-","P","L","A","I","N"], newEndString: ["-","P","L","A","N","E"], insertCost: 1, deleteCost: 1, subCost: 2)
//let sw = alignStrings(newStartString: ["-","F","L","O","U","R"], newEndString: ["-","F","L","O","W","E","R"], insertCost: 1, deleteCost: 1, subCost: 2)
//let sw = alignStrings(newStartString: ["-","A","H","I","G","H","S","T","E","P"], newEndString: ["-","H","G","I","H","A","P","E"], insertCost: 1, deleteCost: 1, subCost: 2)

let sw = alignStrings(newStartString: ["-","A","C","G","T","C","A","T","C","A"], newEndString: ["-","T","A","G","T","G","T","C","A"], insertCost: 1, deleteCost: 1, subCost: 2)

if py == sw {
    print("pass")
} else {
    print("fail")
    print(sw)
}

// FIX MAX Number on exponential
