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
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
