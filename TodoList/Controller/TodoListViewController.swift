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
    
    // Add Item Action
    @IBAction func addItem(_ sender: Any) {
        let newRow = lists.count
        let item = TodoList()
        item.title = "Hello, I'm new row"
        lists.append(item)
        
        let indexPath = IndexPath(row: newRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! TodoListViewCell

        // Configure the cell...
        let list = lists[indexPath.row]
        cell.configure(list)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           // Delete Row
           if editingStyle == .delete {
               lists.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .automatic)
           }
           
           
       }
    
}

// MARK: - Table View Delegate

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TodoListViewCell {
            if lists[indexPath.row].ischecked == true {
                cell.button.setTitle("⏺", for: .normal)
            } else {
                cell.button.setTitle("☑️", for: .normal)
            }
            lists[indexPath.row].isToggle()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
   
}
