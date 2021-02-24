//
//  MainScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit
import SpriteKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lastWordOneLabel: UITextField!
    @IBOutlet weak var lastWordTwoLabel: UITextField!
    
    var wordOneList = [String]()
    var wordTwoList = [String]()
    var listData = WordDataLoader() // New
    var entries = [String]() // New
    var realRowCount = 3
    var realColumnCount = 3
    
    let defaults = UserDefaults.standard
    var selectedWordOne = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    var selectedWordTwo = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    lazy var tableViewDisplayList = wordOneList
    
    override func viewWillAppear(_ animated: Bool) {
        listData.loadData(filename: "WordData")
        wordOneList = listData.getEntires(index: realColumnCount)
        wordTwoList = listData.getEntires(index: realRowCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determinCorrectWordSize()
        checkIfFirstRun()
        loadUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadUserData()
    }
    
    func checkIfFirstRun() {
        if !defaults.bool(forKey: "Not First Launch") {
            let legendData = [["Square", 15], ["Insert", 13], ["Delete", 6], ["Substitute", 0], ["No Opperation", 15], ["Processing Halo", 24], ["Final Path", 24], ["Final Letters", 17], ["Gameboard", 1], ["Gameboard Text", 0]]
            
            defaults.set(legendData, forKey: "Legend Preferences")
            defaults.set(2, forKey: "Snake Speed Text Setting")
            defaults.set(0.25, forKey: "Snake Move Speed")
//            defaults.set(true, forKey: "Food Weight Setting")
            defaults.set(true, forKey: "Food Count Setting")
            defaults.set(false, forKey: "God Button On Setting")
            defaults.set(true, forKey: "Volume On Setting")
            defaults.set(true, forKey: "Dark Mode On Setting")
            defaults.set(true, forKey: "Not First Launch")
            defaults.set(true, forKey: "Game Is Paused Setting")
            defaults.set(true, forKey: "Display Grid Setting")
            
            defaults.set(true, forKey: "Vibrate On Setting")
            defaults.set(3, forKey: "Square Size Setting")
            defaults.set(1, forKey: "Minimum Word Repeat Setting")
            // Bug fix: prevents nil nil from occupying gamescreen on first launch.
            defaults.set(wordOneList[0], forKey: "Selected Path Finding Algorithim Name")
            defaults.set(wordTwoList[0], forKey: "Selected Maze Algorithim Name")
            defaults.set("None", forKey: "lastWordOne")
            defaults.set("None", forKey: "lastWordTwo")
            
            defaults.set(1, forKey: "Insert Cost Setting")
            defaults.set(1, forKey: "Delete Cost Setting")
            defaults.set(2, forKey: "Substitute Cost Setting")
            defaults.set(1, forKey: "No Operation Cost Setting")
            defaults.set(1, forKey: "Minimum Word Repeat Setting")
            
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func determinCorrectWordSize() {
        let squareWidth = 46
        let frame = UIScreen.main.bounds.size
        // -5 == -4 Due to buffer squares and -1 becouse word plist starts at 0.
        realRowCount = (Int(((frame.height)/CGFloat(squareWidth)).rounded(.up)) - 5)
        realColumnCount = (Int(((frame.width)/CGFloat(squareWidth)).rounded(.up)) - 5)
        print(realRowCount, realColumnCount)
        
    }
    
    func loadUserData() {
        lastWordTwoLabel.text = "\(defaults.string(forKey: "lastWordOne")!)"
        lastWordOneLabel.text = "\(defaults.string(forKey: "lastWordTwo")!)"
        defaults.bool(forKey: "Dark Mode On Setting") ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        segControl.font(name: "Dogica_Pixel", size: 9)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return tableViewDisplayList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.label.text = tableViewDisplayList[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 0 {
            selectedWordOne = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Path Finding Algorithim")
            defaults.set(wordOneList[indexPath.row], forKey: "Selected Path Finding Algorithim Name")
        }
        if segControl.selectedSegmentIndex == 1 {
            selectedWordTwo = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Maze Algorithim")
            defaults.set(wordTwoList[indexPath.row], forKey: "Selected Maze Algorithim Name")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var choice = Int()
        segControl.selectedSegmentIndex == 0 ? (choice = selectedWordOne) : (choice = selectedWordTwo)
        defaults.set(segControl.selectedSegmentIndex, forKey: "Main Screen Segmented Control Choice")
        tableView.selectRow(at: [0, choice], animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameScreen") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        
        let pathFindingAlgorithimName = UserDefaults.standard.string(forKey: "Selected Path Finding Algorithim Name")
        let mazeGenerationAlgorithimName = UserDefaults.standard.string(forKey: "Selected Maze Algorithim Name")
        UserDefaults.standard.set(pathFindingAlgorithimName, forKey: "lastWordTwo")
        UserDefaults.standard.set(mazeGenerationAlgorithimName, forKey: "lastWordOne")
    }
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        segControl.selectedSegmentIndex == 0 ? (tableViewDisplayList = wordOneList) : (tableViewDisplayList = wordTwoList)
        tableVIew.reloadData()
    }
}
