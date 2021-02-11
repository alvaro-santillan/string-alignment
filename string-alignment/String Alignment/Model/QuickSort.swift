//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/12/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class QuickSort {
//    https://www.youtube.com/watch?v=MZaf_9IZCrc
    weak var scene: GameScene!
    var pendingAnimations = [[SkNodeLocationAndColor]]()
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initialGameBoardAperianceSaver() -> [UIColor] {
        var initialGameboardLayout: [UIColor] = []
        for i in scene.playableGameboard {
            initialGameboardLayout.append(i.square.fillColor)
        }
        return initialGameboardLayout
    }
    
    func initialGameBoardAperianceRestorer(resuming: Bool, initialGameboardLayout: [UIColor]) {
        // Prevents sorted array grid from appering before initial animations begin.
        // If animation has to restart, prevents sorted array grid from apperaing before animations begin.
        if resuming == false {
//            for i in scene.playableGameboard {
//                i.square.fillColor = scene.gameboardSquareColor
//            }
        } else {
            for (index, i) in (scene.playableGameboard).enumerated() {
                i.square.fillColor = initialGameboardLayout[index]
            }
        }
    }
    
    func quickSortHelper(resuming: Bool) -> [[SkNodeLocationAndColor]]{
        // Save the gameboard apperiance before animations.
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        // Run Quick sort on the graph.
        quickSort(frontPointer: 0, endPointer: scene.playableGameboard.count-1)
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
    
    func quickSort(frontPointer: Int, endPointer: Int) {
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
                if jIndexColorAlpha > endPointerAlpha {
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
            quickSort(frontPointer: frontPointer, endPointer: iIndex)
            quickSort(frontPointer: iIndex+2, endPointer: endPointer)
        }
    }
}
