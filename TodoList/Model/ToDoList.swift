//
//  ToDoList.swift
//  TodoList
//
//  Created by Amin  on 6/7/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import Foundation


class ToDoList: NSObject, Codable {
    
    var name: String = ""
    var items: [ToDoItems] = []
    var iconModel = "No Icon"
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    // Count the unchecked items
    func countUncheckedItems() -> Int {
        return items.reduce(0) { (result, item) in
            result + (item.ischecked ? 0 : 1)
        }
    }
}
