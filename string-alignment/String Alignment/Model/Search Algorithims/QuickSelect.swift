//
//  QuickSelect.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/12/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class QuickSelect {
    weak var scene: GameScene!
    var pendingAnimations = [[SkNodeLocationAndColor]]()
    var searchTargetSquare: [SkNodeAndLocation] = []
    var targetSquareFound = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func quickSelectHelper() -> ([[SkNodeLocationAndColor]], Bool, [SkNodeAndLocation]) {
        let target = scene.gameBoard.first(where: { $0.location == Tuple(x: Int.random(in: 1...7), y: Int.random(in: 1...13))})!
        let targetAlpha = target.square.fillColor.toComponents().alpha
        // Run Quick sort on the graph.
        quickSelect(frontPointer: 0, endPointer: scene.playableGameboard.count-1, target: targetAlpha)
        return(pendingAnimations, targetSquareFound, searchTargetSquare)
    }
    
        func quickSelect(frontPointer: Int, endPointer: Int, target: CGFloat) {
        let playableGameboard = scene.playableGameboard
        
        if frontPointer == endPointer {
            return
        } else if endPointer < frontPointer {
            return
        }
        
        let endPointerColor = playableGameboard[endPointer].square.fillColor
        let endPointerAlpha = endPointerColor.toComponents().alpha
        var jIndex = frontPointer
        var iIndex = frontPointer-1
        
        for _ in (frontPointer...(endPointer-1)) {
            if jIndex < (playableGameboard.count-1) {
                let jIndexColorAlpha = playableGameboard[jIndex].square.fillColor.toComponents().alpha
                let jIndexColor = playableGameboard[jIndex].square.fillColor
                if jIndexColorAlpha < endPointerAlpha {
                    iIndex += 1
                    let tempIValue = playableGameboard[iIndex].square.fillColor
                    playableGameboard[iIndex].square.fillColor = playableGameboard[jIndex].square.fillColor
                    playableGameboard[jIndex].square.fillColor = tempIValue
                    
                    let newIIndex = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: playableGameboard[iIndex].location, color: jIndexColor)
                    let newJIndex = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: playableGameboard[jIndex].location, color: tempIValue)
                    pendingAnimations.append([newJIndex, newIIndex])
                } else {
                    let newJIndex = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: playableGameboard[jIndex].location, color: playableGameboard[jIndex].square.fillColor)
                    pendingAnimations.append([newJIndex])
                }
                jIndex += 1
            }
        }
        let finalPivotValue = playableGameboard[iIndex+1].square.fillColor
        playableGameboard[iIndex+1].square.fillColor = endPointerColor
        playableGameboard[endPointer].square.fillColor = finalPivotValue
        
        let newIPlusOneColor = SkNodeLocationAndColor(square: playableGameboard[iIndex+1].square, location: playableGameboard[iIndex+1].location, color: endPointerColor)
        let newEndPointerColor = SkNodeLocationAndColor(square: playableGameboard[endPointer].square, location: playableGameboard[endPointer].location, color: finalPivotValue)
        pendingAnimations.append([newEndPointerColor, newIPlusOneColor])
        
        if endPointer-1 != frontPointer {
            quickSelect(frontPointer: frontPointer, endPointer: iIndex, target: target)
            quickSelect(frontPointer: iIndex+2, endPointer: endPointer, target: target)
        }
    }
}
