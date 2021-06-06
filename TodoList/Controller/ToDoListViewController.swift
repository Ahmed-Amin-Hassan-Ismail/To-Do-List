//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Amin  on 5/31/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // Instance Variable
    var lists: [ToDoList] = []
    
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
        
        // Load data
        loadToDoList()
        
        // Return Document Directory
        print("Document folder is: -  \(documentDirectory())")
        print("Data File Path is: - \(dataFilePath())")
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! ToDoListViewCell
        
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
            
            // Saving Data
            saveToDoList()
        }
    }
}

// MARK: - Table View Delegate

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoListViewCell {
            let item = lists[indexPath.row]
            cell.checkIfCompleted(item)
        }
        checkSorted()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        
        // Saving Data
        saveToDoList()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AddItem Delegate

extension ToDoListViewController: ItemDetailViewControllerDelegate {
    
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoList) {
        let newRow = lists.count
        lists.append(item)
        
        let indexPath = IndexPath(row: newRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        
        // Saving Data
        saveToDoList()
        
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoList) {
        if let index = lists.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ToDoListViewCell {
                cell.configure(item)
                
                // Saving Data
                saveToDoList()
            }
        }
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
    
}


// MARK: - Private Methods

extension ToDoListViewController {
    
    private func checkSorted() {
        lists = lists.sorted(by: {(!$0.ischecked) && ($1.ischecked)})
    }
    
    private func sortedByName() {
        lists = lists.sorted(by: {($0.title) < ($1.title)})
    }
    
    // Document Folder Path
    private func documentDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("ToDoList.plist")
    }
    
    // Save data to file
    private func saveToDoList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(),
                           options: .atomic)
        } catch {
            print("Error while encoding lists \(error.localizedDescription)")
        }
        
    }
    
    // Load data from file
    private func loadToDoList() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([ToDoList].self, from: data)
            } catch {
                print("Error while decoding lists \(error.localizedDescription)")
            }
        }
    }
    
}
