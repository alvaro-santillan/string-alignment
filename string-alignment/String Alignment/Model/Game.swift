//
//  Game.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameManager {
    weak var audioPlayer: AVAudioPlayer?
    weak var viewController: GameScreenViewController!
    var play = true
    var gameStarted = false
    var mazeGenerated = false
    var matrix = [[Int]]()
    var moveInstructions = [Int]()
    var pathBlockCordinates = [Tuple]()
    var pathBlockCordinatesNotReversed = [Tuple]()
    var onPathMode = false
    weak var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Float = 1
    var paused = false
    var playerDirection: Int = 3 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    var barrierNodesWaitingToBeDisplayed: [SkNodeAndLocation] = []
    var barrierNodesWaitingToBeRemoved: [SkNodeAndLocation] = []
    var verticalMaxBoundry = Int()
    var verticalMinBoundry = Int()
    var horizontalMaxBoundry = Int()
    var horizontalMinBoundry = Int()
    var foodPosition: [SkNodeAndLocation] = []
    
    var target: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    var binarySearHistory: [[SkNodeAndLocation]] = []
    var targetFound = false
    
    init(scene: GameScene) {
        self.scene = scene
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
        }
    }
    
    // Sort
    var orderedSquareShades: [SkNodeLocationAndColor] = []
    var shuffledSquareShades: [SkNodeLocationAndColor] = []
    var swapSquareAndColor = [[SkNodeLocationAndColor]]()
    var swapAnimationsSplit = [[[SkNodeLocationAndColor]]]()
    
    func roundUp(factor: Int, n: Int) -> Int {
        return (n + 24) / 25 * 25;
    }
    
    
    
    func initaitateRandomSquares() {
        var colorArray = [Float]()
        let playableGameboardSize = scene!.playableGameboardSize
        
        if scene.nativeBoardLayoutOption == 5 { // 5 Few Unique
            let divideFactor = playableGameboardSize/6
            for i in 1...playableGameboardSize+1 {
                let newI = roundUp(factor: divideFactor, n: i)
                colorArray.append(1 - Float(newI)/Float(playableGameboardSize))
            }
        } else {
            for i in 0...playableGameboardSize {
                colorArray.append(1 - Float(i)/Float(playableGameboardSize))
            }
        }
        
        // Animation 1: Displays colors in order
        // Use pointers instead of array value removals.
        var colorArrayTwo = colorArray
        for (skNodeAndLocation) in scene.gameBoard {
            if skNodeAndLocation.location.x != 0 && skNodeAndLocation.location.x != (scene.rowCount - 1) {
                if skNodeAndLocation.location.y != 0 && skNodeAndLocation.location.y != (scene.columnCount - 1) {
                    skNodeAndLocation.square.fillColor = scene.squareColor.withAlphaComponent(CGFloat(colorArrayTwo.first ?? 0.1234))
                    orderedSquareShades.append(SkNodeLocationAndColor(square: skNodeAndLocation.square, location: skNodeAndLocation.location, color: skNodeAndLocation.square.fillColor))
                    colorArrayTwo.removeFirst()
                }
            }
        }
        
        print("current board layout", scene.nativeBoardLayoutOption)
        if scene.nativeBoardLayoutOption == 1 || scene.nativeBoardLayoutOption == 2 || scene.nativeBoardLayoutOption == 5 { // No Change, Randomize Board, Few Unique
            colorArray.shuffle()
        } else if scene.nativeBoardLayoutOption == 3 { // 3 Most
            let arrayCount = Int(colorArray.count/6)
            let upperSortedSquares = (colorArray.count) - arrayCount
            colorArray[arrayCount...upperSortedSquares].shuffle()
        } else if scene.nativeBoardLayoutOption == 4 { // 4 Few
            let arrayCount = Int(colorArray.count/6)
            let upperSortedSquares = (colorArray.count) - arrayCount
            colorArray[...arrayCount].shuffle()
            colorArray[upperSortedSquares...].shuffle()
        } else if scene.nativeBoardLayoutOption == 6 { // 6 Top
            let validTopSquares = ((scene.rowCount - 2)/3) * (scene.columnCount - 2)
            colorArray[...(validTopSquares - 1)].shuffle()
        } else if scene.nativeBoardLayoutOption == 7 { // 7 Center
           let validCenterSquares = ((scene.rowCount - 2)/3) * (scene.columnCount - 2)
            colorArray[validCenterSquares...((colorArray.count - validCenterSquares) - 2)].shuffle()
        } else if scene.nativeBoardLayoutOption == 8 { // 8 Bottom
           let validBottomSquares = ((scene.rowCount - 2)/3) * (scene.columnCount - 2)
            colorArray[((colorArray.count - validBottomSquares) + 1)...].shuffle()
        } else if scene.nativeBoardLayoutOption == 9 { // 9 Reverse Sorted
            colorArray.reverse()
        } else if scene.nativeBoardLayoutOption == 10 { // 10 Sorted
            // Do nothing
        }
        
        // Animation 2: Squares are suffled
        for (skNodeAndLocation) in scene.gameBoard {
            if skNodeAndLocation.location.x != 0 && skNodeAndLocation.location.x != (scene.rowCount - 1) {
                if skNodeAndLocation.location.y != 0 && skNodeAndLocation.location.y != (scene.columnCount - 1) {
                    skNodeAndLocation.square.fillColor = scene.squareColor.withAlphaComponent(CGFloat(colorArray.first ?? 1.0))
                    shuffledSquareShades.append(SkNodeLocationAndColor(square: skNodeAndLocation.square, location: skNodeAndLocation.location, color: skNodeAndLocation.square.fillColor))
                    colorArray.removeFirst()
                }
            }
        }
        
        sortSelector(resuming: false)
        searchSelector()

    }
    
    func sortSelector(resuming: Bool) {
        
        if scene.pathFindingAlgorithimChoice == 0 {
            // Hack to get search animations to run by them selves.
            let newI = SkNodeLocationAndColor(square: scene.playableGameboard[0].square, location: scene.playableGameboard[0].location, color: scene.playableGameboard[0].square.fillColor)
            swapSquareAndColor.append([newI])
        } else if scene.pathFindingAlgorithimChoice == 1 {
            let bs = BubbleSort(scene: scene)
            swapSquareAndColor = bs.bubbleSort(resuming: resuming)
        } else if scene.pathFindingAlgorithimChoice == 2 {
            let iss = InsertionSort(scene: scene)
            swapSquareAndColor = iss.insertionSort(resuming: resuming)
        } else if scene.pathFindingAlgorithimChoice == 3 {
            let qs = QuickSortAndMedianOfMedians(scene: scene)
            swapSquareAndColor = qs.quickSortHelper(resuming: resuming)
        } else if scene.pathFindingAlgorithimChoice == 4 {
            let nqs = QuickSort(scene: scene)
            swapSquareAndColor = nqs.quickSortHelper(resuming: resuming)
        } else if scene.pathFindingAlgorithimChoice == 5 {
            let ss = SelectionSort(scene: scene)
            swapSquareAndColor = ss.selectionSort(resuming: resuming)
        }  else {
            print("Out Of Bounds Error", scene.pathFindingAlgorithimChoice)
        }
    }
    
    func searchSelector() {
        if scene.mazeGeneratingAlgorithimChoice == 2 {
            let linear = (scene.gameBoard)
            let ls = LinearSearch(scene: scene)
            (searchHistory, targetFound, target) = ls.LinearSearch(gameboard: linear)
        } else if scene.mazeGeneratingAlgorithimChoice == 1 {
            let bis = BinarySearch(scene: scene)
            (searchHistory, targetFound, target) = bis.binarySearchHandler()
        } else if scene.mazeGeneratingAlgorithimChoice == 3 {
            let js = JumpSearch(scene: scene)
            (searchHistory, targetFound, target) = js.jumpSearch()
        }
    }
    
    func bringOvermatrix(tempMatrix: [[Int]]) {
        matrix = tempMatrix
    }
    
    func update(time: Double) {
            
        if nextTime == nil {
            nextTime = time + Double(gameSpeed)
        } else if (paused == true) {
            if gameIsOver != true {
                checkIfPaused()
            }
        }
        else {
            if time >= nextTime! {
                if gameIsOver != true {
                    nextTime = time + Double(gameSpeed)
                    barrierSquareManager()
//                    scene.updateScoreButtonHalo()
                    scene.updateScoreButtonText()
                    checkIfPaused()
                }
            }
        }
    }
    
    func barrierSquareManager() {
        barrierNodesWaitingToBeDisplayed = Array(Set(barrierNodesWaitingToBeDisplayed).subtracting(barrierNodesWaitingToBeRemoved))
        barrierNodesWaitingToBeRemoved.removeAll()
    }
    
    var gameAnimationsWereRemoved = false
    func checkIfPaused() {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") && scene.gamboardAnimationEnded {
            for i in scene.gameBoard {
                i.square.removeAllActions()
                i.square.strokeColor = .clear
                i.square.run(SKAction.scale(to: 1.0, duration: 0))
            }
            gameAnimationsWereRemoved = true
            scene.squareColoringWhileSnakeIsMoving()
            paused = true
        } else {
            if gameAnimationsWereRemoved == true {
                sortSelector(resuming: true)
                gameAnimationsWereRemoved = false
            }
            paused = false
        }
    }
    
    var gameIsOver = Bool()
    func endTheGame() {
        scene.algorithimChoiceName.text = "Game Over"
        self.viewController?.scoreButton.layer.borderColor = UIColor.red.cgColor
//        updateScore()
        gameIsOver = true
        mazeGenerated = false
        currentScore = 0
        scene.animationDualButtonManager(buttonsEnabled: false)
    }
    
    func playSound(selectedSoundFileName: String) {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        let musicPath = Bundle.main.path(forResource: selectedSoundFileName, ofType:"wav")!
        let url = URL(fileURLWithPath: musicPath)
        
        if UserDefaults.standard.bool(forKey: "Volume On Setting") {
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer = sound
                sound.play()
            } catch {
                print("Error playing file")
            }
        }
    }
}
