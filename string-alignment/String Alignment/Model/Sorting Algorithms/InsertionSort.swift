//
//  InsertionSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/4/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class InsertionSort {
    weak var scene: GameScene!
    
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

    func insertionSort(resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var pendingAnimations = [[SkNodeLocationAndColor]]()
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        let playableGameboard = scene.playableGameboard
        
        for (i, _) in playableGameboard.enumerated() {
            var j = i - 1
            var i = i

            if j != -1 && i != -1 {
                var iColor = playableGameboard[i].square.fillColor
                var iColorAlpha = iColor.toComponents().alpha
                var jColor = playableGameboard[j].square.fillColor
                var jColorAlpha = jColor.toComponents().alpha
                
                if j != -1 && i != -1 && iColorAlpha < jColorAlpha {
                    let J = SkNodeLocationAndColor(square: playableGameboard[j].square, location: playableGameboard[j].location, color: jColor)
                    pendingAnimations.append([J])
                }
            
                while j != -1 && i != -1 && iColorAlpha >= jColorAlpha {
                    // Swap square colors on phisical board data structure for Bubble sort.
                    playableGameboard[i].square.fillColor = jColor
                    playableGameboard[j].square.fillColor = iColor
                    
                    // Swap square colors for animation data structure.
                    let newI = SkNodeLocationAndColor(square: playableGameboard[i].square, location: playableGameboard[i].location, color: jColor)
                    let newJ = SkNodeLocationAndColor(square: playableGameboard[j].square, location: playableGameboard[j].location, color: iColor)
                    pendingAnimations.append([newI, newJ])
                    
                    j = j - 1
                    i = i - 1
                    if j != -1 && i != -1 {
                        iColor = playableGameboard[i].square.fillColor
                        iColorAlpha = iColor.toComponents().alpha
                        jColor = playableGameboard[j].square.fillColor
                        jColorAlpha = jColor.toComponents().alpha
                    }
                }
            }
        }

        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
}
