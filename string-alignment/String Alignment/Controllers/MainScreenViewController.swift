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
    @IBOutlet weak var lastWordOneLabel: UITextField!
    @IBOutlet weak var lastWordTwoLabel: UITextField!
    
    let wordOneList = [["Abstractionist","0","0"], ["Attractiveness","0","0"], ["Bioengineering","0","0"], ["Cinematography","0","0"], ["Detoxification","0","0"], ["Distinguishing","0","0"], ["Indestructible","0","0"], ["Liberalization","0","0"], ["Mountaineering","0","0"], ["Pharmaceutical","0","0"], ["Quintessential","0","0"], ["Superstructure","0","0"], ["Thoughtfulness","0","0"], ["Weightlessness","0","0"], ["Widespreadness","0","0"]]
    
    let wordTwoList = [["agile","0","0"], ["alert","0","0"], ["belly","0","0"], ["bench","0","0"], ["cross","0","0"], ["crowd","0","0"], ["fears","0","0"], ["fermi","0","0"], ["hacks","0","0"], ["krill","0","0"], ["logos","0","0"], ["omits","0","0"], ["peach","0","0"], ["swirl","0","0"], ["yummy","0","0"]]
    
    let defaults = UserDefaults.standard
    var selectedWordOne = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    var selectedWordTwo = UserDefaults.standard.integer(forKey: "Selected Maze Algorithim")
    lazy var tableViewDisplayList = wordOneList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfFirstRun()
        loadUserData()
    }
    
    func checkIfFirstRun() {
        if !defaults.bool(forKey: "Not First Launch") {
            let legendData = [["Square", 13], ["Insert", 6], ["Delete", 9], ["Substitute", 0], ["No Opperation", 24], ["Processing Halo", 19], ["Final Path", 31], ["Final Letters", 31], ["Gameboard", 1], ["Gameboard Text", 31]]
            
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
            
            
            defaults.set(1, forKey: "Insert Cost Setting")
            defaults.set(1, forKey: "Delete Cost Setting")
            defaults.set(2, forKey: "Substitute Cost Setting")
            defaults.set(1, forKey: "No Operation Cost Setting")
            defaults.set(1, forKey: "Reset Setting")
            
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func loadUserData() {
        lastWordTwoLabel.text = "\(defaults.integer(forKey: "highScore"))"
        lastWordOneLabel.text = "\(defaults.integer(forKey: "lastScore"))"
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
            selectedWordOne = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Path Finding Algorithim")
            defaults.set(wordOneList[indexPath.row][0], forKey: "Selected Path Finding Algorithim Name")
        }
        if segControl.selectedSegmentIndex == 1 {
            selectedWordTwo = indexPath.row
            defaults.set(indexPath.row, forKey: "Selected Maze Algorithim")
            defaults.set(wordTwoList[indexPath.row][0], forKey: "Selected Maze Algorithim Name")
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
    }
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        segControl.selectedSegmentIndex == 0 ? (tableViewDisplayList = wordOneList) : (tableViewDisplayList = wordTwoList)
        tableVIew.reloadData()
    }
}
