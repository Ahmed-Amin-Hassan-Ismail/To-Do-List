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
        
    }
    
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Hide Empty Rows
        tableView.tableFooterView = UIView()
        
        
        var item1 = TodoList()
        item1.title = "Learn iOS Development"
        lists.append(item1)
        
        item1 = TodoList()
        item1.title = "Learn Different Design Pattern"
        lists.append(item1)
        
        item1 = TodoList()
        item1.title = "Learn Realm DataBase"
        lists.append(item1)
        
        item1 = TodoList()
        item1.title = "learn third party library"
        lists.append(item1)
        
        item1 = TodoList()
        item1.title = "Learn Swift Language"
        lists.append(item1)
        
        
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
                controller.itemToEdit = lists[indexPath.row]
            }
        }
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
            let item = lists[indexPath.row]
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

extension TodoListViewController: ItemDetailViewControllerDelegate {
    
    
    func AddItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func AddItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: TodoList) {
        let newRow = lists.count
        lists.append(item)
        
        let indexPath = IndexPath(row: newRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func AddItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: TodoList) {
        if let index = lists.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TodoListViewCell {
                cell.configure(item)
            }
        }
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
    
}


// MARK: - Private Methods

extension TodoListViewController {
    
    private func checkSorted() {
          lists = lists.sorted(by: {(!$0.ischecked) && ($1.ischecked)})
      }
    
    private func sortedByName() {
        lists = lists.sorted(by: {($0.title) < ($1.title)})
    }
    
}
