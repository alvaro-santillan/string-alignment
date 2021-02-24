//
//  StringAlignment.swift
//  Sort N Search
//
//  Created by Al on 2/20/21.
//  Copyright © 2021 Álvaro Santillan. All rights reserved.
//

// Known bug: word prossessing section is missing a edge case. Look into minRepeat.
// Failed: "A","C","G","T","C","A","T","C","A". insertCost = 1 deleteCost = 1 subCost = 2 minRepeat = 1
import Foundation
import UIKit

class StringAlignment {
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func stringFormater(startString: String) -> [String] {
        var upperCasedStartString = Array(startString.uppercased())
        upperCasedStartString.insert("-", at: upperCasedStartString.startIndex)
        
        var startStringArray = [String]()
        for letter in upperCasedStartString {
            startStringArray.append(String(letter))
        }
        
        return startStringArray
    }
    
    func alignStrings(startString: [String], endString: [String], insertCost: Int, deleteCost: Int, subCost: Int) -> ([[Int]], [[SkCompleteNode]]) {
        var pendingAnimations = [[SkCompleteNode]]()
        let playableGameboard = scene.playableGameboard
        // The worst score, so algorithim can only improve.
        // delete, sub, or insert cost of more then ten will cause a integer overflow.
        let infinity = Int.max-10
        var costMatrix = [[Int]]()
        
        // Create initial worst case matrix.
        for _ in 0...startString.count - 1 {
            var tempArray = [Int]()
            for _ in 0...endString.count - 1 {
                tempArray.append(infinity)
            }
            costMatrix.append(tempArray)
        }
        
        func findNewColor(targetLocation: Tuple) -> UIColor {
            for (_, row) in pendingAnimations.enumerated() {
                for (_, jrow) in row.enumerated() {
                    if jrow.location == targetLocation {
                        return jrow.color
                    }
                }
            }
            return .black
        }

        var squareCounter = (scene.columnCount - 1) // HARDCODED
        
        // Update matrix to better values.
        for x in 0...startString.count - 1 {
            for y in 0...endString.count - 1 {
                // Calculate operation costs.
                let diagonal = (x-1 != -1) && (y-1 != -1) ? costMatrix[x-1][y-1] : infinity
                let diagonalPlusCost = diagonal + subCost
                let topPlusCost = (x-1 != -1) ? costMatrix[x-1][y] + deleteCost : infinity
                let leftPlusCost = (y-1 != -1) ? costMatrix[x][y-1] + insertCost : infinity
                
                var currentLocationAndSquare = SkCompleteNode(square: playableGameboard[0].square, location: playableGameboard[0].location, color: .black, value: 0, operationType: "-")
                var comparisonLocationAndSquare = SkCompleteNode(square: playableGameboard[0].square, location: playableGameboard[0].location, color: .black, value: 0, operationType: "-")
                let currentSquare = playableGameboard[squareCounter].square
                let currentLocation = playableGameboard[squareCounter].location
                // HARDCODED
                let topSquare = playableGameboard[squareCounter - (scene.columnCount - 2)].square
                let topLocation = playableGameboard[squareCounter - (scene.columnCount - 2)].location
                let diagnalSquare = playableGameboard[squareCounter - (scene.columnCount - 3)].square
                let diagnalLocation = playableGameboard[squareCounter - (scene.columnCount - 3)].location
                let leftSquare = playableGameboard[squareCounter - 1].square
                let leftLocation = playableGameboard[squareCounter - 1].location
                var newCurrentSquareColor = UIColor()
                var newCumparisonSquareColor = UIColor()
                
                // Replace value in matrix with lowest option.
                if endString[y] == "-" && startString[x] == "-" {
                    // Populate first spot with 0 runs once.
                    costMatrix[x][y] = 0
                    
                    // Animations
                    currentLocationAndSquare = SkCompleteNode(square: currentSquare, location: currentLocation, color: scene.noOpperationColor, value: 0, operationType: "No Operation")
                    pendingAnimations.append([currentLocationAndSquare])
                } else if endString[y] == "-" {
                    // Populate the first x and y columns in the matrix.
                    let newDeleteCost = x * deleteCost
                    costMatrix[x][y] = newDeleteCost
                    
                    // Animations
                    newCumparisonSquareColor = findNewColor(targetLocation: topLocation)
                    currentLocationAndSquare = SkCompleteNode(square: currentSquare, location: currentLocation, color: scene.deleteColor, value: newDeleteCost, operationType: "Delete")
                    comparisonLocationAndSquare = SkCompleteNode(square: topSquare, location: topLocation, color: newCumparisonSquareColor, value: -1, operationType: "-")
                    pendingAnimations.append([currentLocationAndSquare,comparisonLocationAndSquare])
                } else if endString[y] == startString[x] {
                    let smallest = min(topPlusCost, leftPlusCost, diagonal)
                    var opperationType = String()
                    costMatrix[x][y] = smallest
                    
                    if smallest == topPlusCost {
                        newCurrentSquareColor = scene.deleteColor
                        opperationType = "Delete"
                        comparisonLocationAndSquare = SkCompleteNode(square: topSquare, location: topLocation, color: findNewColor(targetLocation: topLocation), value: -1, operationType: "-")
                    } else if smallest == leftPlusCost {
                        newCurrentSquareColor = scene.insertColor
                        opperationType = "Insert"
                        comparisonLocationAndSquare = SkCompleteNode(square: leftSquare, location: leftLocation, color: findNewColor(targetLocation: leftLocation), value: -1, operationType: "-")
                    } else {
                        newCurrentSquareColor = scene.noOpperationColor
                        opperationType = "No Operation"
                        comparisonLocationAndSquare = SkCompleteNode(square: diagnalSquare, location: diagnalLocation, color: findNewColor(targetLocation: diagnalLocation), value: -1, operationType: "-")
                    }
                    
                    // Animations
                    currentLocationAndSquare = SkCompleteNode(square: currentSquare, location: currentLocation, color: newCurrentSquareColor, value: smallest, operationType: opperationType)
                    pendingAnimations.append([currentLocationAndSquare,comparisonLocationAndSquare])
                } else {
                    let smallest = min(topPlusCost, leftPlusCost, diagonalPlusCost)
                    var opperationType = String()
                    costMatrix[x][y] = smallest
                    
                    if smallest == topPlusCost {
                        newCurrentSquareColor = scene.deleteColor
                        opperationType = "Delete"
                        comparisonLocationAndSquare = SkCompleteNode(square: topSquare, location: topLocation, color: findNewColor(targetLocation: topLocation), value: -1, operationType: "-")
                    } else if smallest == leftPlusCost {
                        newCurrentSquareColor = scene.insertColor
                        opperationType = "Insert"
                        comparisonLocationAndSquare = SkCompleteNode(square: leftSquare, location: leftLocation, color: findNewColor(targetLocation: leftLocation), value: -1, operationType: "-")
                    } else {
                        newCurrentSquareColor = scene.substituteColor
                        opperationType = "Substitute"
                        comparisonLocationAndSquare = SkCompleteNode(square: diagnalSquare, location: diagnalLocation, color: findNewColor(targetLocation: diagnalLocation), value: -1, operationType: "-")
                    }
                    
                    // Animations
                    currentLocationAndSquare = SkCompleteNode(square: currentSquare, location: currentLocation, color: newCurrentSquareColor, value: smallest, operationType: opperationType)
                    pendingAnimations.append([currentLocationAndSquare,comparisonLocationAndSquare])
                }
                
                // HARDCODED
                if y == scene.pathFindingAlgorithimName?.count {
                    squareCounter += 2
                } else {
                    squareCounter += 1
                }
            }
        }
        return (costMatrix, pendingAnimations)
    }

    func extractAlignment(costMatrix: [[Int]], startString: [String], endString: [String], insertCost: Int, deleteCost: Int, subCost: Int) -> ([String], [SkNodeAndLocation], Bool, [SkNodeAndLocation]) {
        var pendingAnimations = [SkNodeAndLocation]()
        let playableGameboard = scene.playableGameboard
        let infinity = Int.max-10

        var target: [SkNodeAndLocation] = []
        var squareCounter = ((scene.columnCount * scene.rowCount) - scene.columnCount - 2) // Last square to get calculated.
        pendingAnimations.append(scene.gameBoard[squareCounter])
        target.append(scene.gameBoard.first(where: { $0.location == Tuple(x: 1, y: 1)})!) // HARDCODED
        
        
        // Variables to track location and store results.
        var optimalOperations = [String]()
        var currentLocationX = startString.count-1
        var currentLocationY = endString.count-1

        // This function finds the optimal path from the bottom right corner to the top left corner.
        while !((startString[currentLocationX] == "-") && ( endString[currentLocationY] == "-")) {
            // Calculate costs and catch out of bound errors.
            let top = (currentLocationX-1 != -1) ? costMatrix[currentLocationX-1][currentLocationY] : infinity
            let left = (currentLocationY-1 != -1) ? costMatrix[currentLocationX][currentLocationY-1] : infinity
            let diagonal = (currentLocationX-1 != -1 && currentLocationY-1 != -1) ? costMatrix[currentLocationX-1][currentLocationY-1] : infinity
                
            // Top is the smallest update and append accordingly.
            if top < left && top < diagonal {
                currentLocationX = currentLocationX-1
                optimalOperations.append("delete")
                
                squareCounter -= scene.columnCount // HARDCODED
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            // Diagonal is the smallest (no-op) update and append accordingly.
            else if diagonal <= top && diagonal <= left && diagonal == costMatrix[currentLocationX][currentLocationY] {
                currentLocationX = currentLocationX-1
                currentLocationY = currentLocationY-1
                optimalOperations.append("no-op")
                
                squareCounter -= 1 // HARDCODED
                squareCounter -= scene.columnCount // HARDCODED
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            // Diagonal is the smallest (sub) update and append accordingly.
            else if diagonal <= top && diagonal <= left && diagonal != costMatrix[currentLocationX][currentLocationY] {
                currentLocationX = currentLocationX-1
                currentLocationY = currentLocationY-1
                optimalOperations.append("sub")
                
                squareCounter -= 1 // HARDCODED
                squareCounter -= scene.columnCount // HARDCODED
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            // Left is the smallest update and append accordingly.
            else if left <= top && left <= diagonal {
                currentLocationY = currentLocationY-1
                optimalOperations.append("insert")
                
                squareCounter -= 1 // HARDCODED
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            
            // The end is reached so can terminate.
            if (currentLocationY == -1 || currentLocationX == -1) {
                break
            }
        }
        return (optimalOperations.reversed(), pendingAnimations, true, target) // HARDCODED
    }

    func commonSubstrings(startString: [String], minRepeat: Int, optimalOperations: [String]) -> ([String], [Int]) {
        // Variables to track location and store results.
        var startPointer = 0
        var endPointer = 0
        var tracker = 0
        var skips = 0
        var returnList = [String]()
        var locations = [Int]()

        // Check for L no-ops until the entire array is traversed.
        while startPointer < (optimalOperations.count) {
            // Handle inserts by adding skips.
            skips = optimalOperations[startPointer] == "insert" ? skips + 1 : skips
            
            // Handle if L no-ops are found.
            if optimalOperations[startPointer] == "no-op" {
                endPointer = startPointer
                // Traverse the array updating "pointers" along the way.
                // The 2nd condition is used to prevent out of index error.
                while endPointer < (optimalOperations.count) && optimalOperations[endPointer] == "no-op" {
                    tracker += 1
                    endPointer += 1
                }
                // Append section into the result array.
                if tracker >= minRepeat {
                    var tempEndPointer = endPointer
                    if tempEndPointer >= startString.count - 1 {
                        tempEndPointer = startString.count - 1
                    }
                    // Word prossessing.
                    if tracker > minRepeat {
                        let tempString = startString[((startPointer + 1) - skips)...tempEndPointer]
                        returnList.append(String(tempString.count) + ", " + tempString.joined())
                        locations.append(contentsOf: tempString.indices)
                    } else if tracker == minRepeat {
                        let tempString = startString[((startPointer + 1) - skips)...(endPointer - skips)]
                        returnList.append(String(tempString.count) + ", " + tempString.joined())
                        locations.append(contentsOf: tempString.indices)
                    }
                }
                // Update pointers and reset the tracker.
                startPointer = endPointer - 1
            }
            startPointer += 1
            tracker = 0
        }
        return (returnList, locations)
    }
}
