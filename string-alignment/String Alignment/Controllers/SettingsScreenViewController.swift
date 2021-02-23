//
//  SettingsScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsSceenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var tableVIew: UITableView!
    
    // Text Buttons
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var substituteButton: UIButton!
    @IBOutlet weak var deleteCostButton: UIButton!
    @IBOutlet weak var animationsButton: UIButton!
    @IBOutlet weak var insertCostButton: UIButton!
    @IBOutlet weak var noOperationCostButton: UIButton!
    @IBOutlet weak var minimumWordRepeatButton: UIButton!
    
    // Icon Buttons
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var vibrationButton: UIButton!
    @IBOutlet weak var darkOrLightModeButton: UIButton!
    
    weak var gameScreenViewController: GameScreenViewController!
    
    let defaults = UserDefaults.standard
    var legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        loadButtonStyling()
    }
    
    func loadUserData() {
        defaults.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    func loadButtonStyling() {
        var options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonLoader(targetButton: speedButton, key: "Snake Speed Text Setting", optionArray: options)
        options = ["Substitute Cost: 1", "Substitute Cost: 2", "Substitute Cost: 3", "Substitute Cost: 4"]
        fourOptionButtonLoader(targetButton: substituteButton, key: "Substitute Cost Setting", optionArray: options)
        options = ["Delete Cost: 1", "Delete Cost: 2", "Delete Cost: 3", "Delete Cost: 4"]
        fourOptionButtonLoader(targetButton: deleteCostButton, key: "Delete Cost Setting", optionArray: options)
        options = ["Insert Cost: 1", "Insert Cost: 2", "Insert Cost: 3", "Insert Cost: 4"]
        fourOptionButtonLoader(targetButton: insertCostButton, key: "Insert Cost Setting", optionArray: options)
        options = ["No Operation Cost: 1", "No Operation Cost: 2", "No Operation Cost: 3", "No Operation Cost: 4"]
        fourOptionButtonLoader(targetButton: noOperationCostButton, key: "No Operation Cost Setting", optionArray: options)
        tenOptionButtonLoader(targetButton: minimumWordRepeatButton, key: "Minimum Word Repeat Setting", optionArray: [1,2,3,4,5,6,7,8,9,10])
        
        boolButtonLoader(isIconButton: true, targetButton: soundButton, key: "Volume On Setting", trueOption: "Volume_On_Icon_Set", falseOption: "Volume_Mute_Icon_Set")
        boolButtonLoader(isIconButton: true, targetButton: vibrationButton, key: "Vibrate On Setting", trueOption: "Vibrate_On_Icon_Set", falseOption: "Vibrate_Off_Icon_Set")
        boolButtonLoader(isIconButton: true, targetButton: darkOrLightModeButton, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon_Set", falseOption: "Light_Mode_Icon_Set")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsScreenTableViewCell
        let cellText = (legendData[indexPath.row][0] as? String)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.legendOptionText.text = legendData[indexPath.row][0] as? String
        cell.legendOptionSquareColor.backgroundColor = colorPaletteManager(cellText: cellText)[(legendData[indexPath.row][1] as? Int)!]
        cell.legendOptionSquareColor.layer.borderWidth = 1
        cell.legendOptionSquareColor.layer.cornerRadius = cell.legendOptionSquareColor.frame.size.width/4
        cell.legendOptionSquareColor.tag = indexPath.row
        cell.legendOptionSquareColor.isUserInteractionEnabled = true
        cell.legendOptionSquareColor.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedSquare = tapGestureRecognizer.view as! UIImageView
        let cellText = legendData[tappedSquare.tag][0] as! String
        let colorPalette = colorPaletteManager(cellText: cellText)
        var colorID = (legendData[tappedSquare.tag][1] as! Int) + 1
        
        colorID == colorPalette.count ? (colorID = 0) : ()
        defaults.setColor(color: colorPalette[(legendData[tappedSquare.tag][1] as! Int)], forKey: legendData[tappedSquare.tag][0] as! String)
        legendData[tappedSquare.tag][1] = colorID
        defaults.set(legendData, forKey: "Legend Preferences")
        tableVIew.reloadData()
        changeNotifier()
    }
    
    @IBAction func speedButtonTapped(_ sender: UIButton) {
        let options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonResponder(sender, isSpeedButton: true, key: "Snake Speed Text Setting", optionArray: options)
    }
    
    @IBAction func substituteCostButtonTapped(_ sender: UIButton) {
        let options = ["Substitute Cost: 1", "Substitute Cost: 2", "Substitute Cost: 3", "Substitute Cost: 4"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Substitute Cost Setting", optionArray: options)
    }
    
    @IBAction func deleteCostButtonTapped(_ sender: UIButton) {
        let options = ["Delete Cost: 1", "Delete Cost: 2", "Delete Cost: 3", "Delete Cost: 4"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Delete Cost Setting", optionArray: options)
    }
    
    @IBAction func animationsButtonTapped(_ sender: UIButton) {
        // To-do
    }
    
    @IBAction func insertCostButtonTapped(_ sender: UIButton) {
        let options = ["Insert Cost: 1", "Insert Cost: 2", "Insert Cost: 3", "Insert Cost: 4"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Insert Cost Setting", optionArray: options)
    }
    
    @IBAction func noOperationCostButtonTapped(_ sender: UIButton) {
        let options = ["No Operation Cost: 1", "No Operation Cost: 2", "No Operation Cost: 3", "No Operation Cost: 4"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "No Operation Cost Setting", optionArray: options)
    }
    
    @IBAction func minimumWordRepeatButtonTapped(_ sender: UIButton) {
        let options = [1,2,3,4,5,6,7,8,9,10]
        tenOptionButtonResponder(sender, isSpeedButton: false, key: "Minimum Word Repeat Setting", optionArray: options)
    }
    
    @IBAction func returnButtonTapped(_ sender: UIButton) {
        defaults.set(true, forKey: "Settings Dismissed")
        self.dismiss(animated: true)
    }
    
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Volume On Setting", trueOption: "Volume_On_Icon_Set", falseOption: "Volume_Mute_Icon_Set")
    }
    
    @IBAction func vibrateButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Vibrate On Setting", trueOption: "Vibrate_On_Icon_Set", falseOption: "Vibrate_Off_Icon_Set")
    }
    
    @IBAction func darkModeButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon_Set", falseOption: "Light_Mode_Icon_Set")
        
        if (defaults.bool(forKey: "Dark Mode On Setting")) == true {
            UIWindow.animate(withDuration: 1.3, animations: {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
                self.overrideUserInterfaceStyle = .dark
                self.presentingViewController?.overrideUserInterfaceStyle = .dark
            })
        } else {
            UIWindow.animate(withDuration: 1.3, animations: {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
                self.overrideUserInterfaceStyle = .light
                self.presentingViewController?.overrideUserInterfaceStyle = .light
            })
        }
        tableVIew.reloadData()
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.gameScreenViewController = (vc.presentedViewController as? GameScreenViewController)

            self.dismiss(animated: true) {
                if self.gameScreenViewController != nil {
                    self.gameScreenViewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
