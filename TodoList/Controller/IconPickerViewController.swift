//
//  IconPickerViewController.swift
//  TodoList
//
//  Created by Amin  on 6/15/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    
    func IconPickerViewController(_ controller: IconPickerViewController,
                                  didPick IconName: String)
}

class IconPickerViewController: UIViewController {
    
    // Instance Variable
    private let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips"
    ]
    
    weak var delegate: IconPickerViewControllerDelegate?

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    

}

// MARK: - Table view Data source

extension IconPickerViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Icons", for: indexPath)
        
        // configure cell...
        cell.textLabel?.text = icons[indexPath.row]
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        
        return cell
    }
}

// MARK: - Table view delegate

extension IconPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let icon = icons[indexPath.row]
        delegate?.IconPickerViewController(self, didPick: icon)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

