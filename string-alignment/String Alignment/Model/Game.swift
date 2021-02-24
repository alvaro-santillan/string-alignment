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
    var verticalMaxBoundry = Int()
    var verticalMinBoundry = Int()
    var horizontalMaxBoundry = Int()
    var horizontalMinBoundry = Int()
    var foodPosition: [SkNodeAndLocation] = []
    
    var target: [SkNodeAndLocation] = []
    var extractAlignmentAnimations: [SkNodeAndLocation] = []
    var binarySearHistory: [[SkNodeAndLocation]] = []
    var targetFound = false
    
    init(scene: GameScene) {
        self.scene = scene
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
        }
    }
    
    var orderedSquareShades: [SkNodeLocationAndColor] = []
    var shuffledSquareShades: [SkNodeLocationAndColor] = []
    var alignStringAnimations = [[SkCompleteNode]]()
    var swapAnimationsSplit = [[[SkNodeLocationAndColor]]]()
    var commonStringAnimations = [Int]()
    
    func roundUp(factor: Int, n: Int) -> Int {
        return (n + 24) / 25 * 25;
    }
    
    func initaitateRandomSquares() {
        var colorArray = [Float]()
        let playableGameboardSize = scene!.playableGameboardSize
        
        for i in 0...playableGameboardSize {
            colorArray.append(1 - Float(i)/Float(playableGameboardSize))
        }
        
        // Animation 1: Displays colors in order
        // Use pointers instead of array value removals.
        var colorArrayTwo = colorArray
        for (skNodeAndLocation) in scene.gameBoard {
            if skNodeAndLocation.location.x != 0 && skNodeAndLocation.location.x != (scene.rowCount - 1) {
                if skNodeAndLocation.location.y != 0 && skNodeAndLocation.location.y != (scene.columnCount - 1) {
                    skNodeAndLocation.square.fillColor = scene.squareColor
                    orderedSquareShades.append(SkNodeLocationAndColor(square: skNodeAndLocation.square, location: skNodeAndLocation.location, color: skNodeAndLocation.square.fillColor))
                    colorArrayTwo.removeFirst()
                }
            }
        }
        
        // Animation 2: Squares are suffled
        for (skNodeAndLocation) in scene.gameBoard {
            if skNodeAndLocation.location.x != 0 && skNodeAndLocation.location.x != (scene.rowCount - 1) {
                if skNodeAndLocation.location.y != 0 && skNodeAndLocation.location.y != (scene.columnCount - 1) {
                    skNodeAndLocation.square.fillColor = scene.squareColor
                    shuffledSquareShades.append(SkNodeLocationAndColor(square: skNodeAndLocation.square, location: skNodeAndLocation.location, color: skNodeAndLocation.square.fillColor))
                    colorArray.removeFirst()
                }
            }
        }
        sortSelector(resuming: false)
    }
    
    func sortSelector(resuming: Bool) {
        let insertCost = UserDefaults.standard.integer(forKey: "Insert Cost Setting")
        let deleteCost = UserDefaults.standard.integer(forKey: "Delete Cost Setting")
        let subCost = UserDefaults.standard.integer(forKey: "Substitute Cost Setting")
        _ = UserDefaults.standard.integer(forKey: "No Operation Cost Setting")
        let minRepeat = UserDefaults.standard.integer(forKey: "Minimum Word Repeat Setting")

        let sa = StringAlignment(scene: scene)
        
        let endString = sa.stringFormater(startString: UserDefaults.standard.string(forKey: "Selected Path Finding Algorithim Name") ?? "ERROR")
        let startString = sa.stringFormater(startString: UserDefaults.standard.string(forKey: "Selected Maze Algorithim Name") ?? "ERROR")
        
        let results = sa.alignStrings(startString: startString, endString: endString, insertCost: insertCost, deleteCost: deleteCost, subCost: subCost)
        let costMatrix = results.0
        alignStringAnimations = results.1
        
        let optimalOperations = sa.extractAlignment(costMatrix: costMatrix, startString: startString, endString: endString, insertCost: insertCost, deleteCost: deleteCost, subCost: subCost)
        extractAlignmentAnimations = optimalOperations.1
        targetFound = optimalOperations.2
        target = optimalOperations.3
        let commonStrings = sa.commonSubstrings(startString: startString, minRepeat: minRepeat, optimalOperations: optimalOperations.0)

//        print("--------------------------Part 1------------------------------")
//        for i in costMatrix {
//            print(i)
//        }
        commonStringAnimations = commonStrings.1
//        print(optimalOperations.0)
//        print(commonStrings.1)
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
//                    scene.updateScoreButtonHalo()
                    scene.updateScoreButtonText()
                    checkIfPaused()
                }
            }
        }
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
