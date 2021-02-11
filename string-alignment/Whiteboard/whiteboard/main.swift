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
    var currentLocationX = 3
    var currentLocationY = 3

    // This function finds the optimal path from the bottom right corner to the top left corner.
    while !((startString[currentLocationX] == "-") && ( endString[currentLocationY] == "-")) {
        // Catch out of bound errors.
        
        var top = Int()
        var left = Int()
        var diagonal = Int()
        
        do {
            top = costMatrix[currentLocationX-1][currentLocationY]
        } catch {
            top = infinity
        }

        do {
            left = costMatrix[currentLocationX][currentLocationY-1]
        } catch {
            left = infinity
        }

        do {
            diagonal = costMatrix[currentLocationX-1][currentLocationY-1]
        } catch {
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
    }

    return optimalOperations.reversed()
}

let costMatrix = alignStrings(startString: ["-","B","E","A","R"], endString: ["-","B","A","R","E"], insertCost: 1, deleteCost: 1, subCost: 2)
for i in costMatrix {
    print(i)
}

print(extractAlignment(costMatrix: costMatrix, startString: ["-","B","E","A","R"], endString: ["-","B","A","R","E"], insertCost: 1, deleteCost: 1, subCost: 2))
