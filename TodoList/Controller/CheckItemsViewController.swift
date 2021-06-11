//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Amin  on 5/31/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class CheckItemsViewController: UITableViewController {
    
    // Instance Variable
    var list: ToDoList!
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Hide Empty Rows
        tableView.tableFooterView = UIView()
        
        // Change navigation bar title 
        title = list.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Sorted Items with names
        sortedByName()
        
        // sorted items with task completed
        checkSorted()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "editItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = list.items[indexPath.row]
            }
        }
    }
    
}


// MARK: - Table view data source

extension CheckItemsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! CheckItemsViewCell
        
        // Configure the cell...
        let item = list.items[indexPath.row]
        cell.configure(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete Row
        if editingStyle == .delete {
            list.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }
}

// MARK: - Table View Delegate

extension CheckItemsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? CheckItemsViewCell {
            let item = list.items[indexPath.row]
            cell.checkIfCompleted(item)
        }
        checkSorted()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AddItem Delegate

extension CheckItemsViewController: ItemDetailViewControllerDelegate {
    
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoItems) {
        let newRow = list.items.count
        list.items.append(item)
        
        let indexPath = IndexPath(row: newRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoItems) {
        if let index = list.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? CheckItemsViewCell {
                cell.configure(item)
            }
        }
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
    
}


// MARK: - Private Methods

extension CheckItemsViewController {
    
    private func checkSorted() {
        list.items = list.items.sorted(by: {(!$0.ischecked) && ($1.ischecked)})
    }
    
    private func sortedByName() {
        list.items = list.items.sorted(by: {($0.title) < ($1.title)})
    }
    
}
