//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/7/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class QuickSortAndMedianOfMedians {
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
        quickSort(array: scene.playableGameboard, frontPointer: 0, endPointer: scene.playableGameboard.count-1)
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
    
    func quickSort(array: [SkNodeAndLocation], frontPointer: Int, endPointer: Int) {
        if frontPointer == endPointer {
            return
        } else if endPointer < frontPointer {
            return
        }
        
        var pivotValue: SkNodeAndLocation
        var pivotColor: UIColor
        var pivotAlpha: CGFloat
        
        if (endPointer - frontPointer) < 5 {
            pivotValue = array[endPointer]
            pivotColor = pivotValue.square.fillColor
            pivotAlpha = pivotValue.square.fillColor.toComponents().alpha
        } else {
            pivotValue = medianOfMedians(array: array, frontPointer: frontPointer, endPointer: endPointer)
            pivotColor = pivotValue.square.fillColor
            pivotAlpha = pivotValue.square.fillColor.toComponents().alpha
        }
        
        var jIndex = frontPointer
        var iIndex = frontPointer-1
        
        for _ in (frontPointer...(endPointer-1)) {
            if jIndex < (array.count-1) {
                let jIndexColorAlpha = array[jIndex].square.fillColor.toComponents().alpha
                let jIndexColor = array[jIndex].square.fillColor
                if jIndexColorAlpha > pivotAlpha {
                    iIndex += 1
                    let tempIValue = array[iIndex].square.fillColor
                    array[iIndex].square.fillColor = array[jIndex].square.fillColor
                    array[jIndex].square.fillColor = tempIValue
                    
                    let newIIndex = SkNodeLocationAndColor(square: array[iIndex].square, location: array[iIndex].location, color: jIndexColor)
                    let newJIndex = SkNodeLocationAndColor(square: array[jIndex].square, location: array[jIndex].location, color: tempIValue)
                    pendingAnimations.append([newJIndex, newIIndex])
                } else {
                    let newJIndex = SkNodeLocationAndColor(square: array[jIndex].square, location: array[jIndex].location, color: array[jIndex].square.fillColor)
                    pendingAnimations.append([newJIndex])
                }
                jIndex += 1
            }
        }
        let finalPivotValue = array[iIndex+1].square.fillColor
        array[iIndex+1].square.fillColor = pivotColor
        array[endPointer].square.fillColor = finalPivotValue
        
        let newIPlusOneColor = SkNodeLocationAndColor(square: array[iIndex+1].square, location: array[iIndex+1].location, color: pivotColor)
        let newEndPointerColor = SkNodeLocationAndColor(square: array[endPointer].square, location: array[endPointer].location, color: finalPivotValue)
        pendingAnimations.append([newEndPointerColor, newIPlusOneColor])
        
        if endPointer-1 != frontPointer {
            quickSort(array: array, frontPointer: frontPointer, endPointer: iIndex)
            quickSort(array: array, frontPointer: iIndex+2, endPointer: endPointer)
        }
    }
    
    func medianOfMedians(array: [SkNodeAndLocation], frontPointer: Int, endPointer: Int) -> SkNodeAndLocation {
        var mediansAlphas = [CGFloat]()
        var mediansObjects = [SkNodeAndLocation]()
        var lastChunckEnd = frontPointer
        
        while (lastChunckEnd + 4) < endPointer {
            let currentChunkEnd = lastChunckEnd + 4
            quickSort(array: scene.playableGameboard, frontPointer: lastChunckEnd, endPointer: currentChunkEnd)
            mediansAlphas.append(array[lastChunckEnd+2].square.fillColor.toComponents().alpha)
            mediansObjects.append(array[lastChunckEnd+2])
            lastChunckEnd = currentChunkEnd + 1
        }
        
        if mediansObjects.count == 1 {
            return mediansObjects[0]
        } else {
            mediansObjects.sort { (Zero, One) -> Bool in
                Zero.square.fillColor.toComponents().alpha < One.square.fillColor.toComponents().alpha
            }
            return mediansObjects[Int(ceil(Float(mediansAlphas.count)/2))-1]
        }
    }
}
