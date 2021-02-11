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
