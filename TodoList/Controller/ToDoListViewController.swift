//
//  ToDoListViewController.swift
//  TodoList
//
//  Created by Amin  on 6/7/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let cellIdentifier = "ToDoList"
    var lists: [ToDoList] = []
    
    
    // MARK: - controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tableView Cell
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        
        // Enable large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Adjust navigation bar title
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        
        
        
        // Hide empty cells
        tableView.tableFooterView = UIView()
        
        // Add some lists
        var list1 = ToDoList(name: "Birthday")
        lists.append(list1)
        
        list1 = ToDoList(name: "Groceries")
        lists.append(list1)
        
        list1 = ToDoList(name: "Cool App")
        lists.append(list1)
        
        // Sorted by name
        sortedByName()
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let listDetailViewController = storyboard?.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        listDetailViewController.delegate = self
        let listToEdit = lists[indexPath.row]
        listDetailViewController.listToEdit = listToEdit
        
        navigationController?.pushViewController(listDetailViewController, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheckItem" {
            let controller = segue.destination as! CheckItemsViewController
            controller.list = sender as? ToDoList
        } else if segue.identifier == "addList" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    
    
    
}

// MARK: - Table view data source

extension ToDoListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        // configure cell...
        cell.textLabel?.text = lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
        
    }
}

// MARK: - Table view delegate

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.row]
        performSegue(withIdentifier: "showCheckItem", sender: list)
    }
}

// MARK: - ListDetailVc delegate

extension ToDoListViewController: ListDetailViewControllerDelegate {
    
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: ToDoList) {
        let newRow = lists.count
        lists.append(list)
        let indexPath = IndexPath(row: newRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // Sorted by name
        sortedByName()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: ToDoList) {
        let index = lists.firstIndex(of: list)!
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.text = list.name
        }
        // Sorted by name
        sortedByName()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Methods
extension ToDoListViewController {
    
    private func sortedByName() {
     lists = lists.sorted(by: {($0.name) < ($1.name)})
    }
}
