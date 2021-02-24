//
//  GameScene.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    // Game construction
    let defaults = UserDefaults.standard
    weak var viewController: GameScreenViewController!
    var game: GameManager!
    var algorithimChoiceName: SKLabelNode!
    var gameBackground: SKShapeNode!
    var gameBoard: [SkNodeAndLocation] = []
    var gameboardEdgeSquares: [SkNodeAndLocation] = []
    var playableGameboard: [SkNodeAndLocation] = []
    var rowCount = 3
    var columnCount = 25
    var squareWidth = CGFloat()
    var currentSquareSizeOption = Int()
    var currentRowOrGridOption = UserDefaults.standard.bool(forKey: "Display Grid Setting")
    var respectRowCount = Bool()
    let pathFindingAlgorithimChoice = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    let mazeGeneratingAlgorithimChoice = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    let pathFindingAlgorithimName = UserDefaults.standard.string(forKey: "Selected Path Finding Algorithim Name")
    let mazeGenerationAlgorithimName = UserDefaults.standard.string(forKey: "Selected Maze Algorithim Name")
    
    // Game settings
    var pathFindingAnimationSpeed = Float()
    var settingsWereChanged = Bool()
    var clearAllWasTapped = Bool()
    var clearPathWasTapped = Bool()
    
    var finalPathColor = UIColor()
    var noOpperationColor = UIColor()
    var processingHaloColor = UIColor()
    var squareColor = UIColor()
    var insertColor = UIColor()
    var deleteColor = UIColor()
    var substituteColor = UIColor()
    var gameboardSquareColor = UIColor()
    var fadedGameBoardSquareColor = UIColor()
    var gameBackgroundColor = UIColor()
    var screenLabelColor = UIColor()
    var scoreButtonColor = UIColor()
    
    var finalLettersColor = UIColor()
    var gameBoardColor = UIColor()
    var GameBoardTextColor = UIColor()
    
//    sort
    var playableGameboardSize = Int()

    override func didMove(to view: SKView) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
        }
        
        if currentRowOrGridOption == true {
            respectRowCount = false
        } else {
            respectRowCount = true
        }
        
        currentSquareSizeOption = UserDefaults.standard.integer(forKey: "Square Size Setting")
        squareSizeManager(squareSizeId: currentSquareSizeOption)
        game = GameManager(scene: self)
        // Disable buttons for initial animation.
        animationDualButtonManager(buttonsEnabled: false)
        settingLoader(firstRun: true)
        createScreenLabels()
        createGameBoard()
        startTheGame()
    }
    
    var nativeBoardLayoutOption = Int()
    func settingLoader(firstRun: Bool) {
        settingsWereChanged = true
        
        // Retrive legend preferences
        let legendData = defaults.array(forKey: "Legend Preferences") as! [[Any]]
        
        // Update pathfinding animation speed
        pathFindingAnimationSpeed = (defaults.float(forKey: "Snake Move Speed") * 2.4)
        
        // Update score button color
        self.viewController?.loadScoreButtonStyling()
        
        // Update square colors, seen by the user in the next frame update.
        squareColor = colors[legendData[0][1] as! Int]
        insertColor = colors[legendData[1][1] as! Int]
        deleteColor = colors[legendData[2][1] as! Int]
        substituteColor = colors[legendData[3][1] as! Int]
        noOpperationColor = colors[legendData[4][1] as! Int]
        processingHaloColor = colors[legendData[5][1] as! Int]
        finalPathColor = colors[legendData[6][1] as! Int]
        finalLettersColor = colors[legendData[7][1] as! Int]
//        gameBoardColor = colors[legendData[8][1] as! Int]
        
        if defaults.bool(forKey: "Dark Mode On Setting") {
            gameboardSquareColor = darkBackgroundColors[legendData[8][1] as! Int]
            fadedGameBoardSquareColor = darkBackgroundColors[legendData[3][1] as! Int].withAlphaComponent(0.5)
            GameBoardTextColor = lightBackgroundColors[legendData[9][1] as! Int]
            gameBackgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
            screenLabelColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
            scoreButtonColor = squareColor
        } else {
            gameboardSquareColor = lightBackgroundColors[legendData[8][1] as! Int]
            fadedGameBoardSquareColor = lightBackgroundColors[legendData[3][1] as! Int].withAlphaComponent(0.5)
            GameBoardTextColor = darkBackgroundColors[legendData[9][1] as! Int]
            gameBackgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
            screenLabelColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
            scoreButtonColor = squareColor
        }
        
        if firstRun {
            // Update to display reset option
            nativeBoardLayoutOption = defaults.integer(forKey: "Minimum Word Repeat Setting")
            // Populate score button text on first run.
            updateScoreButtonText()
        } else {
            for square in playableGameboard {
                let label = square.square.childNode(withName: "squareLabelNode") as? SKLabelNode
                label?.fontColor = GameBoardTextColor
            }
            
            if nativeBoardLayoutOption != defaults.integer(forKey: "Minimum Word Repeat Setting") {
//                for i in gameBoard {
//                    i.square.removeAllActions()
//                }
//                self.viewController?.loadThePausedButton()
//                endingAnimationCount = 0
                game.alignStringAnimations.removeAll()
                game.extractAlignmentAnimations.removeAll()
                insertCounter = 0
                deleteCounter = 0
                nativeBoardLayoutOption = defaults.integer(forKey: "Minimum Word Repeat Setting")
                game.initaitateRandomSquares()
                self.startingAnimationAndSquareColoring()
            }
            
            // Update stored UI colors.
            gameBackground!.fillColor = gameBackgroundColor
            gameBackground!.strokeColor = gameBackgroundColor
            algorithimChoiceName.fontColor = screenLabelColor

            let prospectSquareSizeOption = UserDefaults.standard.integer(forKey: "Square Size Setting")
            if currentSquareSizeOption != prospectSquareSizeOption || currentRowOrGridOption != defaults.bool(forKey: "Display Grid Setting") {
                if currentRowOrGridOption != defaults.bool(forKey: "Display Grid Setting") {
                    if defaults.bool(forKey: "Display Grid Setting") {
                        respectRowCount = false
                        currentRowOrGridOption = true
                    } else {
                        currentRowOrGridOption = false
                        respectRowCount = true
                        rowCount = 3
                    }
                }
                squareSizeManager(squareSizeId: prospectSquareSizeOption)
                depopulateGameBoard()
                createGameBoard()
                gamboardAnimationEnded = false
                startTheGame()
            }
            
            var redOne: CGFloat = 0
            var greenOne: CGFloat = 0
            var blueOne: CGFloat = 0
            var alphaOne: CGFloat = 0
            for i in gameBoard {
                i.square.removeAllActions()
                i.square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                i.square.fillColor = squareColor.withAlphaComponent(alphaOne)
                i.square.strokeColor = .clear
                i.square.run(SKAction.scale(to: 1.0, duration: 0))
            }
            game.sortSelector(resuming: true)
        }
        // Render the changed square color live.
        settingsChangeSquareColorManager()
        defaults.set(false, forKey: "Settings Value Modified")
        defaults.set(false, forKey: "Settings Dismissed")
    }
    
    // Effects happen in real time.
    func squareSizeManager(squareSizeId: Int) {
        switch squareSizeId {
        case 1:
            squareWidth = 35
        case 2:
            squareWidth = 40
        // Always Case 3
        case 3:
            squareWidth = 46
        case 5:
            squareWidth = 50
        default:
            squareWidth = 35
        }
    }
    
    // Contains duplicate functions.
    func settingsChangeSquareColorManager() {
        func colorTheGameboard() {
            for i in gameboardEdgeSquares {
                i.square.fillColor = fadedGameBoardSquareColor
            }
        }
        colorTheGameboard()
    }
    
    private func createScreenLabels() {
        algorithimChoiceName = SKLabelNode(fontNamed: "Dogica_Pixel")
        
        if pathFindingAlgorithimName == nil || mazeGenerationAlgorithimName == nil {
            algorithimChoiceName.text = "Oops Something Went Wrong"
        } else if pathFindingAlgorithimName == "None" && mazeGenerationAlgorithimName == "None" {
            algorithimChoiceName.text = "No Words Selected"
        } else if pathFindingAlgorithimName == "None" {
            algorithimChoiceName.text = "\(mazeGenerationAlgorithimName ?? "")"
        } else if mazeGenerationAlgorithimName == "None" {
            algorithimChoiceName.text = "\(pathFindingAlgorithimName ?? "")"
        } else {
            algorithimChoiceName.text = "\(pathFindingAlgorithimName ?? "") & \(mazeGenerationAlgorithimName ?? "")"
        }
        algorithimChoiceName.fontColor = screenLabelColor
        algorithimChoiceName.fontSize = 11
        algorithimChoiceName.horizontalAlignmentMode = .center
        algorithimChoiceName.position = CGPoint(x: 0, y: 185)
        algorithimChoiceName.zPosition = 1
        self.addChild(algorithimChoiceName)
    }
    
    func depopulateGameBoard() {
        gameBoard.removeAll()
    }
    
    func stringFormater(startString: String, addExtraSpace: Bool) -> [String] {
        var upperCasedStartString = Array(startString.uppercased())
        upperCasedStartString.insert(" ", at: upperCasedStartString.startIndex)
        
        if addExtraSpace == true {
            upperCasedStartString.insert(" ", at: upperCasedStartString.startIndex)
        }
        
        var startStringArray = [String]()
        for letter in upperCasedStartString {
            startStringArray.append(String(letter))
        }
        
        return startStringArray.reversed()
    }
    
    private func createGameBoard() {
        func createBackground() {
            let screenSizeRectangle = CGRect(x: 0-frame.size.width/2, y: 0-frame.size.height/2, width: frame.size.width, height: frame.size.height)
            gameBackground = SKShapeNode(rect: screenSizeRectangle)
            gameBackground.fillColor = gameBackgroundColor
            gameBackground.strokeColor = gameBackgroundColor
            gameBackground.name = "gameBackground"
            self.addChild(gameBackground)
        }
        

        let realRowCount = Int(((frame.size.height)/squareWidth).rounded(.up)) // 17
        rowCount = realRowCount
        
        let realColumnCount = Int(((frame.size.width)/squareWidth).rounded(.up)) // 30
        columnCount = realColumnCount
        
        var matrix = [[Int]]()
        var row = [Int]()
        let shrinkRatio: CGFloat = 0.06
        let cornerRatio: CGFloat = 0.14
        let shrinkedSquareWidth = squareWidth - (squareWidth * shrinkRatio)
        let shrinkedSquareCornerRadius = squareWidth * cornerRatio
        var xAncor = CGFloat(0 - (Int(squareWidth) * columnCount)/2)
        var yAncor = CGFloat(0 + (Int(squareWidth) * rowCount)/2)
        xAncor = CGFloat(xAncor + (squareWidth/2))
        yAncor = CGFloat(yAncor - (squareWidth/2))
        
        createBackground()
        
        var tempUpperWord = stringFormater(startString: pathFindingAlgorithimName!, addExtraSpace: true)
        var tempLeftWord = stringFormater(startString: mazeGenerationAlgorithimName!, addExtraSpace: false)
        
        for x in 0...rowCount - 1 {
            for y in 0...columnCount - 1 {
                let square = SKShapeNode.init(rectOf: CGSize(width: shrinkedSquareWidth, height: shrinkedSquareWidth), cornerRadius: shrinkedSquareCornerRadius)
            
                let squareLabelNode = SKLabelNode(fontNamed: "Dogica_Pixel")
                squareLabelNode.name = "squareLabelNode"
                squareLabelNode.fontColor = GameBoardTextColor
                squareLabelNode.fontSize = 17 // HARDCODED
                squareLabelNode.horizontalAlignmentMode = .center
                squareLabelNode.verticalAlignmentMode = .center
                squareLabelNode.zPosition = 1
                
                // Make gameboard edges unexsesible and dimmer.
                if x == 0 || x == (rowCount - 1) {
                    row.append(9)
                    square.fillColor = fadedGameBoardSquareColor
                    gameboardEdgeSquares.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                } else if y == 0 || y == (columnCount - 1) {
                    row.append(9)
                    square.fillColor = fadedGameBoardSquareColor
                    gameboardEdgeSquares.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                } else if x == 1 {
                    row.append(0)
                    square.fillColor = gameboardSquareColor
                    playableGameboardSize += 1
                    playableGameboard.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                    squareLabelNode.text = tempUpperWord.popLast()
                    square.addChild(squareLabelNode)
                } else if y == 1 {
                    row.append(0)
                    square.fillColor = gameboardSquareColor
                    playableGameboardSize += 1
                    playableGameboard.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                    squareLabelNode.text = tempLeftWord.popLast()
                    square.addChild(squareLabelNode)
                } else {
                    row.append(0)
                    square.fillColor = gameboardSquareColor
                    playableGameboardSize += 1
                    playableGameboard.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                    squareLabelNode.text = "∞"
                    square.addChild(squareLabelNode)
                }
                
                square.name = String(x) + "," + String(y)
                square.position = CGPoint(x: xAncor, y: yAncor)
                square.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                
                
                gameBoard.append(SkNodeAndLocation(square: square, location: Tuple(x: x, y: y)))
                gameBackground.addChild(square)
                
                xAncor += squareWidth
            }
            matrix.append(row)
            row = [Int]()
            // Update x and y
            xAncor = CGFloat(xAncor - CGFloat(Int(squareWidth) * columnCount))
            yAncor -= squareWidth
        }
        game.bringOvermatrix(tempMatrix: matrix)
    }
    
    private func startTheGame() {
        let topCenter = CGPoint(x: 0, y: (frame.size.height / 2) - 25)
        algorithimChoiceName.run(SKAction.move(to: topCenter, duration: 0.4)) {
            self.game.initaitateRandomSquares()
            self.startingAnimationAndSquareColoring()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if defaults.bool(forKey: "Game Is Paused Setting") {
            barrierManager(touches: touches)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if defaults.bool(forKey: "Game Is Paused Setting") {
            barrierManager(touches: touches)
        }
    }
    
    func barrierManager(touches: Set<UITouch>) {
        func selectSquareFromTouch(_ touchLocation: CGPoint) -> SKShapeNode? {
            let squares = self.nodes(at: touchLocation)
            for square in squares {
                if square is SKShapeNode {
                    if square.name != "gameBackground" {
                        return (square as! SKShapeNode)
                    }
                }
            }
            return nil
        }
        
        for touch in touches {
            if let selectedSquare = selectSquareFromTouch(touch.location(in: self)) {
                let squareLocationAsString = (selectedSquare.name)?.components(separatedBy: ",")
                let squareLocation = Tuple(x: Int(squareLocationAsString![0])!, y: Int(squareLocationAsString![1])!)
                let vibration = UIImpactFeedbackGenerator(style: .medium)
                
                if squareLocation.x != 0 && squareLocation.x != (rowCount - 1) {
                    if squareLocation.y != 0 && squareLocation.y != (columnCount - 1) {
                        if defaults.bool(forKey: "Vibrate On Setting") {
                            vibration.impactOccurred()
                        }
                    }
                }
                // Aniation is broken.
                selectedSquare.run(animationSequanceManager(animation: 2))
            }
        }
    }
    
    // Animations
    var gamboardAnimationEnded = Bool()
    
    func startingAnimationAndSquareColoring() {
        // 1
        func gameBoardAnimation(_ nodes: [SkNodeAndLocation]) {
            let lastIndex = ((nodes.count) - 1)
            var gameBoardSquareWait = SKAction()
            for (squareIndex, squareAndLocation) in nodes.enumerated() {
                if squareIndex != lastIndex {
                    squareAndLocation.square.run(.sequence([gameBoardSquareWait, animationSequanceManager(animation: 1)]))
                }
                gameBoardSquareWait = .wait(forDuration: TimeInterval(squareIndex) * 0.003) // 0.003
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + gameBoardSquareWait.duration) {
                foodSquareAnimationBegining()
            }
        }
        
        // 4
        func foodSquareAnimationBegining() {
            var randomSquareWait = SKAction()
            
            let squareLocationAndColor = game.shuffledSquareShades.first
                randomSquareWait = .wait(forDuration: TimeInterval(1) * 1)
            squareLocationAndColor!.square.run(.sequence([randomSquareWait, animationSequanceManager(animation: 1)]), completion: {foodSquareAnimationEnding(squareLocationAndColor: squareLocationAndColor!, randomSquareWait: randomSquareWait)})
        }
        
        // 5
        func foodSquareAnimationEnding(squareLocationAndColor: SkNodeLocationAndColor, randomSquareWait: SKAction) {
            squareLocationAndColor.square.run(SKAction.colorTransitionActionFill(fromColor: squareLocationAndColor.square.fillColor, toColor: squareLocationAndColor.color, duration: 0.5))
            
            // Note this is run to many way to many times. !!!
            DispatchQueue.main.asyncAfter(deadline: .now() + randomSquareWait.duration) {
                self.gamboardAnimationEnded = true
                self.animationDualButtonManager(buttonsEnabled: true)
            }
        }
        gameBoardAnimation(gameBoard)
    }
    
    var firstAnimationSequanceHasCompleted = Bool()
    var pathFindingAnimationsHaveEnded = Bool()
    var visitedSquareDispatchCalled = Bool()
    var pathSquareDispatchCalled = Bool()
    var visitedSquareWait = SKAction()
    var pathSquareWait = SKAction()
    var insertCounter = Float()
    var deleteCounter = Float()
    var substituteCounter = Float()
    var noOpperationCounter = Float()
    var hasRun = false
    var sucssesfullyFound = false
    var endingAnimationCount = Double()
    
    func stringAlignmentAnimationsAndSquareColoring() {
        func alignAnimationBegining() {
            var queuedSquareWait = SKAction()
            pathFindingAnimationsHaveEnded = false
            
            for (squareIndex, innerSquareArray) in game.alignStringAnimations.enumerated() {
                for squareLocationColorAndValue in innerSquareArray {
                    squareLocationColorAndValue.square.run(.sequence([queuedSquareWait]), completion: {alignAnimationEnding(squareLocationColorAndValue: squareLocationColorAndValue, swap: true, duration: queuedSquareWait)})
                }
                queuedSquareWait = .wait(forDuration: TimeInterval(squareIndex) * Double(pathFindingAnimationSpeed))
                game.alignStringAnimations.remove(at: 0)
            }
        }
        
        func alignAnimationEnding(squareLocationColorAndValue: SkCompleteNode, swap: Bool, duration: SKAction) {
            squareLocationColorAndValue.square.fillColor = squareLocationColorAndValue.color
            squareLocationColorAndValue.square.lineWidth = 5
            
            if swap == true {
                squareLocationColorAndValue.square.run(SKAction.colorTransitionAction(fromColor: .clear, toColor: processingHaloColor, duration: 0.5))
                squareLocationColorAndValue.square.run(SKAction.colorTransitionAction(fromColor: processingHaloColor, toColor: .clear, duration: 0.5))
                
                if squareLocationColorAndValue.value != -1 {
                    let squareLabelNode = squareLocationColorAndValue.square.childNode(withName: "squareLabelNode") as? SKLabelNode
                    squareLabelNode?.text = String(squareLocationColorAndValue.value)
                    squareLabelNode?.fontSize = 12
                } else if squareLocationColorAndValue.location.y == 2 && squareLocationColorAndValue.location.x == 2 {
                    let squareLabelNode = squareLocationColorAndValue.square.childNode(withName: "squareLabelNode") as? SKLabelNode
                    squareLabelNode?.text = "0"
                    squareLabelNode?.fontSize = 12
                }
                
                if squareLocationColorAndValue.operationType == "No Operation" {
                    noOpperationCounter += 1
                } else if squareLocationColorAndValue.operationType == "Delete" {
                    deleteCounter += 1 // Good
                } else if squareLocationColorAndValue.operationType == "Insert" {
                    insertCounter += 1 // Good
                } else if squareLocationColorAndValue.operationType == "Substitute" {
                    substituteCounter += 1
                }
                endingAnimationCount += 1.0
            }
            updateScoreButtonText()
            
            if hasRun == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration.duration + endingAnimationCount) {
                    if (self.hasRun == false) {
                        self.gamboardAnimationEnded = true
                        self.animationDualButtonManager(buttonsEnabled: true)
                        extractAlignmentAnimationBegining()
                    }
                    self.hasRun = true
                }
            }
        }
        
        func extractAlignmentAnimationBegining() {
            if game.target.count != 0 {
                var searchWaitTime = SKAction()
                
                for (squareIndex, squareLocationAndColor) in game.extractAlignmentAnimations.enumerated() {
                    squareLocationAndColor.square.run(.sequence([searchWaitTime]), completion: {extractAlignmentAnimationEnding(searchWaitTime: searchWaitTime, squareLocationAndColor: squareLocationAndColor)})
                    searchWaitTime = .wait(forDuration: TimeInterval(squareIndex) * 0.02) // 0.085
                }
            }
        }
        
        func extractAlignmentAnimationEnding(searchWaitTime: SKAction, squareLocationAndColor: SkNodeAndLocation) {
            squareLocationAndColor.square.lineWidth = 5
            squareLocationAndColor.square.strokeColor = self.finalPathColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + searchWaitTime.duration) {
                if self.sucssesfullyFound == false {
                    if (self.game.targetFound) == true {
                        self.sucssesfullyFound = true
                        commonStringsAnimationBegining()
                    }
                }
            }
        }
        
        func commonStringsAnimationBegining() {
            if game.target.count != 0 {
                var searchWaitTime = SKAction()
                
                for (squareIndex, location) in game.commonStringAnimations.enumerated() {
                    let squareLabelNode = gameBoard.first(where: { $0.location == Tuple(x: (location + 2), y: 1)})! // HARDCODED
                    squareLabelNode.square.run(.sequence([searchWaitTime]), completion: {commonStringsAnimationEnding(squareLocationColorAndValue: squareLabelNode, swap: true, duration: searchWaitTime)})
                    searchWaitTime = .wait(forDuration: TimeInterval(squareIndex + 1) * 0.4) // 0.085
                }
            }
        }
        
        func commonStringsAnimationEnding(squareLocationColorAndValue: SkNodeAndLocation, swap: Bool, duration: SKAction) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration.duration) {
                squareLocationColorAndValue.square.fillColor = self.finalLettersColor
                squareLocationColorAndValue.square.lineWidth = 5
            }
        }
        
        visitedSquareDispatchCalled = false
        pathSquareDispatchCalled = false
        
        // Reset Counters before every animation.
        insertCounter = 0
        deleteCounter = 0
        substituteCounter = 0
        noOpperationCounter = 0
        
        alignAnimationBegining()
    }
    
    func squareColoringWhileSnakeIsMoving() {
        if pathFindingAnimationsHaveEnded == true && game.paused == false {
            colorTheGameboard()
        }
    }
    
    // Start: Square coloring helper functions.
    func colorTheGameboard() {
        for i in gameBoard {
            if i.location.x == 0 || i.location.x == (rowCount - 1) {
                i.square.fillColor = fadedGameBoardSquareColor
            } else if i.location.y == 0 || i.location.y == (columnCount - 1) {
                i.square.fillColor = fadedGameBoardSquareColor
            } else {
                i.square.fillColor = gameboardSquareColor
            }
        }
    }
    
    func colorTheRandomSquares() {
        for i in (game.foodPosition) {
            i.square.fillColor = squareColor
        }
    }
    
    // Start: Animation helper function.
    func animationSequanceManager(animation: Int) -> SKAction {
        let wait0 = SKAction.wait(forDuration: 0.80)
        let wait1 = SKAction.wait(forDuration: 0.16)
        let wait2 = SKAction.wait(forDuration: 0.07)
        let grow1 = SKAction.scale(by: 1.05, duration: 0.10)
        let scale1 = SKAction.scale(to: 1.0, duration: 0.12)
        let shrink1 = SKAction.scale(by: 0.90, duration: 0.10)
        let shrink2 = SKAction.scale(by: 0.95, duration: 0.05)
        let shrink3 = SKAction.scale(by: 0.95, duration: 0.10)
        let shrink4 = SKAction.scale(by: 0.97, duration: 0.05)
        let shrink5 = SKAction.scale(by: 0.75, duration: 0.05)
        let colorChange = SKAction.colorize(with: UIColor.blue, colorBlendFactor: 1, duration: 1)

        if animation == 1 {
            return SKAction.sequence([wait0, grow1, wait1, shrink1, wait1, scale1, shrink2, wait2, scale1])
        } else if animation == 2 {
            return SKAction.sequence([grow1, wait1, shrink3, wait1, scale1, shrink4, wait2, scale1])
        } else {
            return SKAction.sequence([shrink5, wait1, scale1])
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Check if user settings were modified.
        if defaults.bool(forKey: "Settings Value Modified") && defaults.bool(forKey: "Settings Dismissed") {
            settingLoader(firstRun: false)
        }
        
        if !(defaults.bool(forKey: "Settings Value Modified")) && (defaults.bool(forKey: "Settings Dismissed")) {
//            gameBackground!.fillColor = gameBackgroundColor

            var redOne: CGFloat = 0
            var greenOne: CGFloat = 0
            var blueOne: CGFloat = 0
            var alphaOne: CGFloat = 0
            for i in gameBoard {
                i.square.removeAllActions()
                i.square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                i.square.fillColor = squareColor.withAlphaComponent(alphaOne)
                i.square.strokeColor = .clear
                i.square.run(SKAction.scale(to: 1.0, duration: 0))
            }
            for i in gameboardEdgeSquares {
                i.square.fillColor = gameboardSquareColor
            }
            game.sortSelector(resuming: true)
            defaults.set(false, forKey: "Settings Value Modified")
            defaults.set(false, forKey: "Settings Dismissed")
        }
        
        // Check if score button was tapped.
        defaults.bool(forKey: "Score Button Is Tapped") ? (updateScoreButtonText()) : ()
        
        if defaults.bool(forKey: "In Settings From Game") {
            for i in gameBoard {
                i.square.removeAllActions()
            }
            defaults.set(false, forKey: "In Settings From Game")
//            noSettingsChange()
        }
        
        if game!.alignStringAnimations.count > 0 && gamboardAnimationEnded == true {
//            print(gamboardAnimationEnded, game!.visitedNodeArray.count)
            if gamboardAnimationEnded == true {
                // Dissble buttons for pathfinding animation.
                animationDualButtonManager(buttonsEnabled: true)
                stringAlignmentAnimationsAndSquareColoring()
            }
            
        } else {
            // new
//            animationDualButtonManager(buttonsEnabled: false)
        }
        game.update(time: currentTime)
    }
    
    func updateScoreButtonText() {
        let scoreButtonTag = self.viewController?.scoreButton.tag
        
        switch scoreButtonTag {
            case 1:
                self.viewController?.scoreButton.setTitle(String(Int(insertCounter)), for: .normal)
            case 2:
                self.viewController?.scoreButton.setTitle(String(Int(deleteCounter)), for: .normal)
            case 3:
                self.viewController?.scoreButton.setTitle(String(Int(substituteCounter)), for: .normal)
            case 4:
                self.viewController?.scoreButton.setTitle(String(Int(noOpperationCounter)), for: .normal)
            default:
                self.viewController?.scoreButton.setTitle(String(Int(insertCounter)), for: .normal)
                print("Score button loading error", self.viewController?.scoreButton.tag as Any)
        }
        defaults.set(false, forKey: "Score Button Is Tapped")
    }
    
    // barrier drawing should not work while animating fix.
    func animationDualButtonManager(buttonsEnabled: Bool) {
        if buttonsEnabled == true {
            self.viewController?.playButton.isEnabled = true
        } else if buttonsEnabled == false {
            self.viewController?.playButton.isEnabled = false
        }
    }
}
