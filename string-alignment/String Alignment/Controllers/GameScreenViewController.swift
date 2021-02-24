//
//  GameScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

class GameScreenViewController: UIViewController {
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    weak var mainScreenViewController: MainScreenViewController!
    weak var gameScreenViewController: GameScreenViewController!
    
    let defaults = UserDefaults.standard
    var legendData = [[Any]]()
    let scenee = SKScene()
    var currentGame: GameManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        homeButtonDisabler()
        loadButtonStyling()
        loadScoreButtonStyling()
        
        if let view = self.view as! SKView? {
            if let scenee = SKScene(fileNamed: "GameScene") {
                // Present the scene
                view.presentScene(scenee)
                currentGame = scenee as? GameManager
                currentGame?.viewController = self
            }
        }
    }
    
    func loadUserData() {
        defaults.bool(forKey: "Dark Mode On Setting") ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    // If home button is pressed right as view loads a memory leak ocurse.
    func homeButtonDisabler() {
        homeButton.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.homeButton.isEnabled = true
        }
    }
    
    func loadThePausedButton() {
        defaults.set(true, forKey: "Game Is Paused Setting")
        boolButtonLoader(isIconButton: true, targetButton: playButton, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
    }
    
    func loadButtonStyling() {
        defaults.set(false, forKey: "Game Is Paused Setting")
        boolButtonLoader(isIconButton: true, targetButton: playButton, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
    }
    
    func loadScoreButtonStyling() {
        legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
        scoreButton.layer.borderWidth = 2
        
        if scoreButton.tag == 0 {
            scoreButton.layer.borderColor = (colors[legendData[2][1] as! Int].withAlphaComponent(0.8)).cgColor
            scoreButton.layer.backgroundColor = (colors[legendData[2][1] as! Int].withAlphaComponent(0.5)).cgColor
        } else if scoreButton.tag == 1 {
            scoreButton.layer.borderColor = (colors[legendData[1][1] as! Int].withAlphaComponent(0.8)).cgColor
            scoreButton.layer.backgroundColor = (colors[legendData[1][1] as! Int].withAlphaComponent(0.5)).cgColor
        } else if scoreButton.tag == 2 {
            scoreButton.layer.borderColor = (colors[legendData[3][1] as! Int].withAlphaComponent(0.8)).cgColor
            scoreButton.layer.backgroundColor = colors[legendData[3][1] as! Int].withAlphaComponent(0.5).cgColor
        } else {
            scoreButton.layer.borderColor = (colors[legendData[4][1] as! Int].withAlphaComponent(0.8)).cgColor
            scoreButton.layer.backgroundColor = colors[legendData[4][1] as! Int].withAlphaComponent(0.5).cgColor
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        defaults.set(true, forKey: "In Settings From Game")
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let vc = appDelegate.window?.rootViewController {
//            self.gameScreenViewController = (vc.presentedViewController as? GameScreenViewController)

//            for i in (currentGame!.scene.gameBoard) {
//                i.square.removeAllActions()
//            }
//        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepButtonTapped(_ sender: UIButton) {
        // If the game is paused, then the correct icon to display is play.
        boolButtonResponder(sender, isIconButton: true, key: "Game Is Paused Setting", trueOption: "Play_Icon_Set", falseOption: "Pause_Icon_Set")
    }
    
    @IBAction func scoreButtonTapped(_ sender: UIButton) {
        // Fixes Bug Score button color dose not respect legend changes.
        legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
        // If button tapped switch to next option.
        switch sender.tag {
            case 0:
                print("Insert count")
                scoreButton.layer.borderColor = (colors[legendData[1][1] as! Int].withAlphaComponent(0.8)).cgColor
                sender.backgroundColor = colors[legendData[1][1] as! Int].withAlphaComponent(0.5)
                sender.tag = 1
            case 1:
                print("Delete count")
                scoreButton.layer.borderColor = (colors[legendData[2][1] as! Int].withAlphaComponent(0.8)).cgColor
                sender.backgroundColor = colors[legendData[2][1] as! Int].withAlphaComponent(0.5)
                sender.tag = 0
            case 2:
                print("Substitute count")
                scoreButton.layer.borderColor = (colors[legendData[3][1] as! Int].withAlphaComponent(0.8)).cgColor
                sender.backgroundColor = colors[legendData[3][1] as! Int].withAlphaComponent(0.5)
                sender.tag = 2
            case 3:
                print("No Opperation count")
                scoreButton.layer.borderColor = (colors[legendData[4][1] as! Int].withAlphaComponent(0.8)).cgColor
                sender.backgroundColor = colors[legendData[4][1] as! Int].withAlphaComponent(0.5)
                sender.tag = 3
            default:
                print("Score button loading error")
        }
        defaults.set(true, forKey: "Score Button Is Tapped")
    }
}
