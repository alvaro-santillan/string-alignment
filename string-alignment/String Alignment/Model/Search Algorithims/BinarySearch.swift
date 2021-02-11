//
//  BinarySearch.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class BinarySearch {
    weak var scene: GameScene!
    var searchTargetSquare: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    var targetSquareFound = false
    var playableGameboard: [SkNodeAndLocation] = []
    var playableGameBoardSize = Int()
    
    init(scene: GameScene) {
        self.scene = scene
        playableGameboard = scene.playableGameboard
        playableGameBoardSize = scene.playableGameboard.count
    }
    
    func binarySearchHandler() -> ([SkNodeAndLocation], Bool, [SkNodeAndLocation]) {
        let randomGameboardSquareIndex = Int.random(in: 1...(playableGameBoardSize-1))
        searchTargetSquare.append(playableGameboard[randomGameboardSquareIndex])
        let playableBoardSize = scene!.playableGameboard.count
        
        for (index, _) in (scene.playableGameboard).enumerated() {
            playableGameboard[index].square.name = String(index)
        }
        
        _ = BinarySearch(targetArray: scene!.playableGameboard, target: randomGameboardSquareIndex, frontPointer: 0, tailPointer: (playableBoardSize-1))
        return(searchHistory, targetSquareFound, searchTargetSquare)
    }
    
    func BinarySearch(targetArray: [SkNodeAndLocation], target: Int, frontPointer: Int, tailPointer: Int) -> Int {
        let center = Int((tailPointer - frontPointer)/2)
        var result = -1
        
        searchHistory.append(playableGameboard[frontPointer])
        searchHistory.append(playableGameboard[center])
        searchHistory.append(playableGameboard[tailPointer])
        
        if target > Int(playableGameboard[playableGameBoardSize - 1].square.name!)! || target < Int(playableGameboard[0].square.name!)! {
            return -1
        }
        
        if Int(playableGameboard[center].square.name!) == target {
            return center
        } else if Int(playableGameboard[frontPointer].square.name!) == target {
            return frontPointer
        } else if Int(playableGameboard[tailPointer].square.name!) == target {
            return tailPointer
        } else if Int(playableGameboard[center].square.name!)! > target {
            result = BinarySearch(targetArray: scene!.playableGameboard, target: target, frontPointer: frontPointer+1, tailPointer: center-1)
        } else if Int(playableGameboard[center].square.name!)! < target {
            result = BinarySearch(targetArray: scene!.playableGameboard, target: target, frontPointer: center+1, tailPointer: tailPointer-1)
        } else if ((frontPointer+1) == center) {
            return -1
        }
        
        if result == target {
            targetSquareFound = true
        }
        return result
    }
}
