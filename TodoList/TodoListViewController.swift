//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Amin  on 5/31/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // Instance Variable
    var lists: [TodoList] = []
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var item1 = TodoList()
        item1.title = "Learn iOS Development"
        lists.append(item1)
        
        item1 = TodoList()
        item1.title = "Learn Different Design Pattern"
        lists.append(item1)
        
        item1 = TodoList()
        item1.title = "Learn Differnt Skills"
        lists.append(item1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}


// MARK: - Table view data source

extension TodoListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoList",
                                                 for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = lists[indexPath.row].title
        cell.accessoryType = (lists[indexPath.row].ischecked) ? .checkmark : .none
        return cell
    }
    
}

// MARK: - Table View Delegate

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if lists[indexPath.row].ischecked == true {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
            lists[indexPath.row].isToggle()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
