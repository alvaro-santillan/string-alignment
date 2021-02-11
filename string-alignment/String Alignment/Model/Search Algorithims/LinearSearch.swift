//
//  LinearSearch.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class LinearSearch {
    weak var scene: GameScene!
    var swapSquareAndColor = [[SkNodeLocationAndColor]]()
    var target: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    var targetFound = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func LinearSearch(gameboard: [SkNodeAndLocation]) -> ([SkNodeAndLocation], Bool, [SkNodeAndLocation]) {
        let randomX = Int.random(in: 1...(scene.rowCount-2))
        let randomY = Int.random(in: 1...(scene.columnCount-2))
        
        print(randomX, randomY)
        target.append(scene.gameBoard.first(where: { $0.location == Tuple(x: randomX, y: randomY)})!)
        
        for i in 0...((scene!.gameBoard.count)-scene.columnCount-3) {
            if targetFound == false {
                if scene.gameBoard[i].location.x != 0 && scene.gameBoard[i].location.x != (scene.rowCount - 1) {
                    if scene.gameBoard[i].location.y != 0 && scene.gameBoard[i].location.y != (scene.columnCount - 1) {
                        if scene.gameBoard[i].location == target[0].location {
                            targetFound = true
                        } else {
                            searchHistory.append(scene.gameBoard[i])
                        }
                    }
                }
            } else {
                break
            }
        }
        return (searchHistory, targetFound, target)
    }
}
