//
//  AddItemViewController.swift
//  TodoList
//
//  Created by Amin  on 6/1/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Laege Title
        navigationItem.largeTitleDisplayMode = .never
        
        // Hide empty rows
        tableView.tableFooterView = UIView()
        
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}



// MARK: - TableView Delegate

extension AddItemViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 100.0
        }
        return 44.0
    }
}
