//
//  DataModel.swift
//  TodoList
//
//  Created by Amin  on 6/12/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [ToDoList]()
    var indexOfSelectedToDoList: Int {
        get {
            UserDefaults.standard.integer(forKey: "CheckItemIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "CheckItemIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadToDoList()
        registerDefaults()
        handleFirstTime()
    }
    
    // Set default value for UserDefault
    private func registerDefaults() {
        
        let dictionary = ["CheckItemIndex": -1,
                          "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Checking for the first time run
    private func handleFirstTime() {
        let userDefault = UserDefaults.standard
        let firstTime = userDefault.bool(forKey: "FirstTime")
        if firstTime {
            let list = ToDoList(name: "List")
            lists.append(list)
            indexOfSelectedToDoList = 0
            userDefault.set(false, forKey: "FirstTime")
            userDefault.synchronize()
        }
    }
    
    
    
    
    
    // Document Folder Path
    private func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("ToDoList.plist")
    }
    
    // save Data
    func saveToDoList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error while encoding list \(error.localizedDescription)")
        }
    }
    
    // Load Data
    private func loadToDoList() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([ToDoList].self, from: data)
            } catch {
                print("Error while decoder list \(error.localizedDescription)")
            }
        }
    }
}
