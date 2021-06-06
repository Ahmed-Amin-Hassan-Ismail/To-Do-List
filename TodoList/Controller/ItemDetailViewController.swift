//
//  AddItemViewController.swift
//  TodoList
//
//  Created by Amin  on 6/1/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    
    func AddItemViewControllerDidCancel(_ controller: ItemDetailViewController)
    func AddItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: TodoList)
    func AddItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: TodoList)
}

class ItemDetailViewController: UITableViewController {
    
    // Edit Item Variable
    var itemToEdit: TodoList?
    
    // Delegate Variable
    weak var delegate: ItemDetailViewControllerDelegate?
    
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Confirm TextField Delegate
        textField.delegate = self
        
        // Disable Laege Title
        navigationItem.largeTitleDisplayMode = .never
        
        // Hide empty rows
        tableView.tableFooterView = UIView()
        
        // Disable Done Button
        doneBarButton.isEnabled = false
        
        // Editing item
        if let item = itemToEdit {
            textField.text = item.title
            title = "Edit Item"
            doneBarButton.isEnabled = true
        }
        
        
        
    }
    
    // Active Keyboard Automatically
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.AddItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.title = textField.text!
            delegate?.AddItemViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = TodoList()
            item.title = textField.text!
            delegate?.AddItemViewController(self, didFinishAdding: item)
        }
    }
}



// MARK: - TableView Delegate

extension ItemDetailViewController {
    
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


// MARK: - TextField Delegate

extension ItemDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
