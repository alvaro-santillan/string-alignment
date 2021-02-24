//
//  WordDataLoader.swift
//  Sort N Search
//
//  Created by Al on 2/23/21.
//  Copyright © 2021 Álvaro Santillan. All rights reserved.
//

import Foundation

class WordDataLoader {
    var wordData = [WordData]()
    
    func loadData(filename: String) {
        if let pathURL = Bundle.main.url(forResource: filename, withExtension: "plist"){
            let plistDecoder = PropertyListDecoder()
            
            do {
                let data = try Data(contentsOf: pathURL)
                wordData = try plistDecoder.decode([WordData].self, from: data)
                print("sd")
            } catch {
                print("O no Bob")
            }
        }
    }
    
    // Getting
    func getLists() -> [String] {
        var lists = [String]()
        for word in wordData {
            lists.append(contentsOf: word.entries)
        }
        return lists
    }
    
    func getEntires(index: Int) -> [String] {wordData[index].entries}
}
