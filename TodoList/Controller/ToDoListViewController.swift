//
//  ToDoListViewController.swift
//  TodoList
//
//  Created by Amin  on 6/7/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var dataModel: DataModel!
    
    // MARK: - controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Adjust navigation bar title
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        
        // Hide empty cells
        tableView.tableFooterView = UIView()
        
        // Sorted by name
        sortedByName()
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let listDetailViewController = storyboard?.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        listDetailViewController.delegate = self
        let listToEdit = dataModel.lists[indexPath.row]
        listDetailViewController.listToEdit = listToEdit
        
        navigationController?.pushViewController(listDetailViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Showing the last opening
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedToDoList
        if index >= 0 && index < dataModel.lists.count {
            let checkItem = dataModel.lists[index]
            performSegue(withIdentifier: "showCheckItem", sender: checkItem)
        }
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
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell: UITableViewCell!
        
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // configure cell...
        let list = dataModel.lists[indexPath.row]
        cell.textLabel?.text = list.name
        cell.imageView?.image = UIImage(named: list.iconModel)
        let count = list.countUncheckedItems()
        cell.detailTextLabel?.text =
            (count == 0) ? "ALL Done💪🏻" : "\(count) Remaining"
        cell.accessoryType = .detailDisclosureButton
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete a list
        if editingStyle == .delete {
            dataModel.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Table view delegate

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Save the last segue
        dataModel.indexOfSelectedToDoList = indexPath.row
        let list = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "showCheckItem", sender: list)
    }
}

// MARK: - ListDetailVc delegate

extension ToDoListViewController: ListDetailViewControllerDelegate {
    
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: ToDoList) {
        let newRow = dataModel.lists.count
        dataModel.lists.append(list)
        let indexPath = IndexPath(row: newRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // Sorted by name
        sortedByName()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: ToDoList) {
        let index = dataModel.lists.firstIndex(of: list)!
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

// MARK: - UINavigation Delegate
extension ToDoListViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        // if the users tapped on back button
        if viewController === self {
            dataModel.indexOfSelectedToDoList = -1
        }
    }
}

// MARK: - Helper Methods
extension ToDoListViewController {
    
    private func sortedByName() {
        dataModel.lists = dataModel.lists.sorted(by: {($0.name) < ($1.name)})
    }
}
