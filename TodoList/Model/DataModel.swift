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
    
    init() {
        loadToDoList()
    }
    
    
    // Document Folder Path
     func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
     func dataFilePath() -> URL {
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
     func loadToDoList() {
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
