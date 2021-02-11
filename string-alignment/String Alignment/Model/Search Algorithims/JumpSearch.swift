//
//  JumpSearch.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/13/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class JumpSearch {
    weak var scene: GameScene!
    var searchTargetSquare: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    var targetSquareFound = false
    var playableGameboard: [SkNodeAndLocation] = []
    var playableGameBoardSize = Int()
    var targetLocation = -1

    init(scene: GameScene) {
        self.scene = scene
        playableGameboard = scene.playableGameboard
        playableGameBoardSize = scene.playableGameboard.count
//        let bs = BubbleSort(scene: scene)
        
//        for (index, i) in (scene.playableGameboard).enumerated() {
//            i.square.fillColor = bs.finalGameboardLayout[index]
//        }
    }

    func jumpSearch() -> ([SkNodeAndLocation], Bool, [SkNodeAndLocation]) {
        print(scene.rowCount)
        print(scene.columnCount)
        let randomX = Int.random(in: 1...(scene.rowCount-2))
        let randomY = Int.random(in: 1...(scene.columnCount-2))
        searchTargetSquare.append(scene.gameBoard.first(where: { $0.location == Tuple(x: randomX, y: randomY)})!)
        let targetValue = searchTargetSquare[0].square.fillColor.toComponents().alpha
        
//        for i in playableGameboard {
//            print(i.square.fillColor)
//        }
        
        let jumpSize = (Int(ceil(sqrt(Float(playableGameboard.count)))) - 1)
    //    print("jump Size", jumpSize)
        var currentJumpLocation = 0
        var nextJumpLocation = (currentJumpLocation + jumpSize)
        var currentJumpLocationValue = playableGameboard[currentJumpLocation].square.fillColor.toComponents().alpha
        var nextJumpLocationValue = playableGameboard[nextJumpLocation].square.fillColor.toComponents().alpha
        
    //    print("explored", currentJumpLocationValue)
        searchHistory.append(playableGameboard[currentJumpLocation])
        if currentJumpLocationValue == targetValue {
            targetSquareFound = true
            targetLocation = currentJumpLocation
    //        print(targetLocation)
        }
        
        while targetSquareFound != true {
    //        print("explored", nextJumpLocationValue)
            searchHistory.append(playableGameboard[nextJumpLocation])
            if nextJumpLocationValue == targetValue {
                targetSquareFound = true
                targetLocation = nextJumpLocation
    //            print(targetLocation)
            }
    //        print("explored", nextJumpLocationValue)
            searchHistory.append(playableGameboard[nextJumpLocation])
            if nextJumpLocationValue < targetValue || nextJumpLocation >= playableGameboard.count {
                for i in currentJumpLocation...(nextJumpLocation-1) {
    //                print("explored", targetArray[i])
                    print("linear")
                    searchHistory.append(playableGameboard[i])
                    if playableGameboard[i].square.fillColor.toComponents().alpha == targetValue {
                        targetSquareFound = true
                        targetLocation = i
    //                    print(targetLocation)
                        break
                    }
                }
                break
            }
    //        print("explored", nextJumpLocationValue)
            searchHistory.append(playableGameboard[nextJumpLocation])
            if nextJumpLocationValue > targetValue {
                if (nextJumpLocation + jumpSize) >= playableGameboard.count {
                    for i in nextJumpLocation...(playableGameboard.count-1) {
    //                    print("explored", targetArray[i])
                        print("linear")
                        searchHistory.append(playableGameboard[i])
                        if playableGameboard[i].square.fillColor.toComponents().alpha == targetValue {
                            targetSquareFound = true
                            targetLocation = i
    //                        print(targetLocation)
                            break
                        }
                    }
                    break
                }
                currentJumpLocation = nextJumpLocation
                currentJumpLocationValue = playableGameboard[currentJumpLocation].square.fillColor.toComponents().alpha
                nextJumpLocation = (currentJumpLocation + jumpSize)
                nextJumpLocationValue = playableGameboard[nextJumpLocation].square.fillColor.toComponents().alpha
            }
        }
        
        if targetSquareFound == false {
            targetLocation = -1
//            print(targetLocation)
            return (searchHistory, targetSquareFound, searchTargetSquare)
        }
        return (searchHistory, targetSquareFound, searchTargetSquare)
    }
}
