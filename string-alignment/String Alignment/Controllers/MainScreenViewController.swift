//
//  MainScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lastScoreLabel: UITextField!
    @IBOutlet weak var highScoreLabel: UITextField!
    
    let pathFindingAlgorithmList = [["None","0","0"], ["Bubble Sort","0","0"], ["Insertion Sort","0","0"], ["Quick Sort With Median Of Medians","0","0"], ["Quick Sort","0","0"], ["Selection Sort","0","0"]]
    
    let mazeGenrationAlgorithimList = [["None","0","0"], ["Binary Search","0","0"], ["Linear Search","0","0"], ["Jump Select","0","0"]]
    
    let defaults = UserDefaults.standard
    var selectedPathAlgorithim = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    var selectedMazeAlgorithim = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    lazy var tableViewDisplayList = pathFindingAlgorithmList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfFirstRun()
        loadUserData()
    }
    
    func checkIfFirstRun() {
        if !defaults.bool(forKey: "Not First Launch") {
            let legendData = [["Square", 13], ["Swap Halo", 6], ["Comparison Halo", 9], ["Gameboard", 0], ["Search Halo", 24], ["Found Halo", 19], ["Target Halo", 31]]
            
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
            defaults.set(1, forKey: "Reset Setting")
            // Bug fix: prevents nil nil from occupying gamescreen on first launch.
            defaults.set("None", forKey: "Selected Path Finding Algorithim Name")
            defaults.set("None", forKey: "Selected Maze Algorithim Name")
            
            
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func loadUserData() {
        highScoreLabel.text = "Last Swaps: \(defaults.integer(forKey: "highScore"))"
        lastScoreLabel.text = "Last Comps: \(defaults.integer(forKey: "lastScore"))"
        defaults.bool(forKey: "Dark Mode On Setting") ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        segControl.font(name: "Dogica_Pixel", size: 9)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return tableViewDisplayList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.label.text = tableViewDisplayList[indexPath.row][0]
        cell.guaranteedIconSquare.contentMode = .scaleAspectFit
        cell.layer.cornerRadius = 5
        
        tableViewDisplayList[indexPath.row][1] == "1" ? (cell.guaranteedIconSquare.image = UIImage(named: "Guaranteed_Icon_Set.pdf")) : (cell.guaranteedIconSquare.image = nil)
        tableViewDisplayList[indexPath.row][2] == "1" ? (cell.optimalIconSquare.image = UIImage(named: "Optimal_Icon_Set.pdf")) : (cell.optimalIconSquare.image = nil)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 0 {
            selectedPathAlgorithim = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Path Finding Algorithim")
            defaults.set(pathFindingAlgorithmList[indexPath.row][0], forKey: "Selected Path Finding Algorithim Name")
        }
        if segControl.selectedSegmentIndex == 1 {
            selectedMazeAlgorithim = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Maze Algorithim")
            defaults.set(mazeGenrationAlgorithimList[indexPath.row][0], forKey: "Selected Maze Algorithim Name")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var choice = Int()
        segControl.selectedSegmentIndex == 0 ? (choice = selectedPathAlgorithim) : (choice = selectedMazeAlgorithim)
        defaults.set(segControl.selectedSegmentIndex, forKey: "Main Screen Segmented Control Choice")
        tableView.selectRow(at: [0, choice], animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameScreen") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        segControl.selectedSegmentIndex == 0 ? (tableViewDisplayList = pathFindingAlgorithmList) : (tableViewDisplayList = mazeGenrationAlgorithimList)
        tableVIew.reloadData()
    }
}
