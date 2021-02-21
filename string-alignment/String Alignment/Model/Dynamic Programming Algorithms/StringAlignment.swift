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
    
    func alignStrings(startString: [String], endString: [String], insertCost: Int, deleteCost: Int, subCost: Int) -> ([[Int]], [[SkNodeLocationAndColor]]) {
        var pendingAnimations = [[SkNodeLocationAndColor]]()
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

        var squareCounter = 18 // HARDCODED
//        var oldX = 0
        
        // Wired Animation Bug Fix.
        var newI = SkNodeLocationAndColor(square: playableGameboard[0].square, location: playableGameboard[0].location, color: .gray)
        pendingAnimations.append([newI])
        newI = SkNodeLocationAndColor(square: playableGameboard[0].square, location: playableGameboard[0].location, color: .gray)
        pendingAnimations.append([newI])
        
        
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
                    
                    let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .yellow)
                    pendingAnimations.append([newI])
                } else if endString[y] == "-" {
                    // Populate the first x and y columns in the matrix.
                    costMatrix[x][y] = x * deleteCost
                    
                    // Animations
                    let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .red)
                    pendingAnimations.append([newI])
//                    print(x, playableGameboard[x].location)
                } else if endString[y] == startString[x] {
                    costMatrix[x][y] = min(topPlusCost, leftPlusCost, diagonal)
                    
                    let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .blue)
                    pendingAnimations.append([newI])
                } else {
                    costMatrix[x][y] = min(topPlusCost, leftPlusCost, diagonalPlusCost)
                    
                    let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .green)
                    pendingAnimations.append([newI])
                }
                
                if y == 14 {
                    squareCounter += 3 // HARDCODED
//                    oldX = x
                } else {
//                print(x)
                    squareCounter += 1 //HARDCODED
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
        var squareCounter = 149 // HARDCODED
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
                
                squareCounter -= 19
//                let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .purple)
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            // Diagonal is the smallest (no-op) update and append accordingly.
            else if diagonal <= top && diagonal <= left && diagonal == costMatrix[currentLocationX][currentLocationY] {
                currentLocationX = currentLocationX-1
                currentLocationY = currentLocationY-1
                optimalOperations.append("no-op")
                
                squareCounter -= 1
                squareCounter -= 19
//                let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .brown)
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            // Diagonal is the smallest (sub) update and append accordingly.
            else if diagonal <= top && diagonal <= left && diagonal != costMatrix[currentLocationX][currentLocationY] {
                currentLocationX = currentLocationX-1
                currentLocationY = currentLocationY-1
                optimalOperations.append("sub")
                
                squareCounter -= 1
                squareCounter -= 19
//                let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .orange)
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            // Left is the smallest update and append accordingly.
            else if left <= top && left <= diagonal {
                currentLocationY = currentLocationY-1
                optimalOperations.append("insert")
                
                squareCounter -= 1
//                let newI = SkNodeLocationAndColor(square: playableGameboard[squareCounter].square, location: playableGameboard[squareCounter].location, color: .systemPink)
                pendingAnimations.append(scene.gameBoard[squareCounter])
            }
            
            // The end is reached so can terminate.
            if (currentLocationY == -1 || currentLocationX == -1) {
                break
            }
        }
        return (optimalOperations.reversed(), pendingAnimations, true, target) // HARDCODED
    }

    func commonSubstrings(startString: [String], minRepeat: Int, optimalOperations: [String]) -> [String] {
        // Variables to track location and store results.
        var startPointer = 0
        var endPointer = 0
        var tracker = 0
        var skips = 0
        var returnList = [String]()

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
                    } else if tracker == minRepeat {
                        let tempString = startString[((startPointer + 1) - skips)...(endPointer - skips)]
                        returnList.append(String(tempString.count) + ", " + tempString.joined())
                    }
                }
                // Update pointers and reset the tracker.
                startPointer = endPointer - 1
            }
            startPointer += 1
            tracker = 0
        }
        return returnList
    }
}
