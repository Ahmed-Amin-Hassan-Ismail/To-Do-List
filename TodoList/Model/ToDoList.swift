//
//  TodoList.swift
//  TodoList
//
//  Created by Amin  on 5/31/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import Foundation
import UIKit

class ToDoList: NSObject, Codable {
    
    var title: String = ""
    var ischecked: Bool = false
    
    func isToggle() {
        ischecked = !ischecked
    }
    
}
