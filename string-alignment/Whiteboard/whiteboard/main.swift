//
//  main.swift
//  sdfg
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

func alignStrings(startString: [String], endString: [String], insertCost: Int, deleteCost: Int, subCost: Int) -> [[Int]] {
    // The worst score, so algorithim can only improve.
    let infinity = Int.max-2
    var costMatrix = [[Int]]()
    
    // Create initial worst case matrix.
    for _ in 0...startString.count - 1 {
        var tempArray = [Int]()
        for _ in 0...endString.count - 1 {
            tempArray.append(infinity)
        }
        costMatrix.append(tempArray)
    }

    // Update matrix to better values.
    for x in 0...startString.count - 1 {
        for y in 0...endString.count - 1 {
            // Calculate operation costs.
            let diagonal = (x-1 != -1) && (y-1 != -1) ? costMatrix[x-1][y-1] : infinity
            let diagonalPlusCost = diagonal + subCost
            let topPlusCost = (x-1 != -1) ? costMatrix[x-1][y] + deleteCost : infinity
            let leftPlusCost = (y-1 != -1) ? costMatrix[x][y-1] + insertCost : infinity
            
            // Replace value in matrix with lowest option.
            if endString[y] == "-" && startString[x] == "-" {
                // Populate first spot with 0 runs once.
                costMatrix[x][y] = 0
            } else if endString[y] == "-" {
                // Populate the first x and y columns in the matrix.
                costMatrix[x][y] = x * deleteCost
            } else if endString[y] == startString[x] {
                costMatrix[x][y] = min(topPlusCost, leftPlusCost, diagonal)
            } else {
                costMatrix[x][y] = min(topPlusCost, leftPlusCost, diagonalPlusCost)
            }
        }
    }
    return costMatrix
}

func extractAlignment(costMatrix: [[Int]], startString: [String], endString: [String], insertCost: Int, deleteCost: Int, subCost: Int) -> [String] {
    let infinity = Int.max-2

    // Variables to track location and store results.
    var optimalOperations = [String]()
    var currentLocationX = startString.count-1
    var currentLocationY = endString.count-1

    // This function finds the optimal path from the bottom right corner to the top left corner.
    while !((startString[currentLocationX] == "-") && ( endString[currentLocationY] == "-")) {
        // Catch out of bound errors.
        
        var top = Int()
        var left = Int()
        var diagonal = Int()
//        print("ran", startString[currentLocationX], endString[currentLocationY])
        
        if (currentLocationX-1 != -1) {
            do {
                top = costMatrix[currentLocationX-1][currentLocationY]
            } catch {
                top = infinity
            }
        } else {
            top = infinity
        }

        if (currentLocationY-1 != -1) {
            do {
                left = costMatrix[currentLocationX][currentLocationY-1]
            } catch {
                left = infinity
            }
        } else {
            left = infinity
        }

        if (currentLocationX-1 != -1 && currentLocationY-1 != -1) {
            do {
                diagonal = costMatrix[currentLocationX-1][currentLocationY-1]
            } catch {
                diagonal = infinity
            }
        } else {
            diagonal = infinity
        }
            
        // Top is the smallest update and append accordingly.
        if top < left && top < diagonal {
            currentLocationX = currentLocationX-1
//            currentLocationY = currentLocationY
            optimalOperations.append("delete")
        }
        // Diagonal is the smallest (no-op) update and append accordingly.
        else if diagonal <= top && diagonal <= left && diagonal == costMatrix[currentLocationX][currentLocationY] {
            currentLocationX = currentLocationX-1
            currentLocationY = currentLocationY-1
            optimalOperations.append("no-op")
        }
        // Diagonal is the smallest (sub) update and append accordingly.
        else if diagonal <= top && diagonal <= left && diagonal != costMatrix[currentLocationX][currentLocationY] {
            currentLocationX = currentLocationX-1
            currentLocationY = currentLocationY-1
            optimalOperations.append("sub")
        }
        // Left is the smallest update and append accordingly.
        else if left <= top && left <= diagonal {
//            currentLocationX = currentLocationX
            currentLocationY = currentLocationY-1
            optimalOperations.append("insert")
        }
        else {
            print("hit")
        }
        
        if (currentLocationY == -1 || currentLocationX == -1) {
            break
        }
    }
    return optimalOperations.reversed()
}

let insertCost = 1
let deleteCost = 1
let subCost = 2
let minRepeat = 1

var startString = ["-","B","E","A","R"]
var endString = ["-","B","A","R","E"]
startString = ["-","P","L","A","I","N"]
endString = ["-","P","L","A","N","E"]
startString = ["-","F","L","O","U","R"]
endString = ["-","F","L","O","W","E","R"]
startString = ["-","A","H","I","G","H","S","T","E","P"]
endString = ["-","H","G","I","H","A","P","E"]
startString = ["-","E","X","P","O","N","E","N","T","I","A","L"]
endString = ["-","P","O","L","Y","N","O","M","I","A","L"]
startString = ["-","A","C","G","T","C","A","T","C","A"]
endString = ["-","T","A","G","T","G","T","C","A"]

let costMatrix = alignStrings(startString: startString, endString: endString, insertCost: insertCost, deleteCost: deleteCost, subCost: subCost)
let optimalOperations = extractAlignment(costMatrix: costMatrix, startString: startString, endString: endString, insertCost: insertCost, deleteCost: deleteCost, subCost: subCost)

print("--------------------------Part 1------------------------------")
for i in costMatrix {
    print(i)
}
print(optimalOperations)
