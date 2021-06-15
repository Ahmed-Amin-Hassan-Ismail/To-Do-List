//
//  ListDetailViewController.swift
//  TodoList
//
//  Created by Amin  on 6/7/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class  {
    
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: ToDoList)
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: ToDoList)
    
}

class ListDetailViewController: UITableViewController {
    
    // Add icons
    var iconFolder = "Folder"
    
    // Editing
    var listToEdit: ToDoList?
    
    // Delegate Variable
    weak var delegate: ListDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var imageLabel: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.ListDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        // for Editing
        if let list = listToEdit {
            list.name = textField.text!
            list.iconModel = iconFolder
            delegate?.ListDetailViewController(self, didFinishEditing: list)
            
        } else {
            // for Adding
            let list = ToDoList(name: textField.text!)
            list.iconModel = iconFolder
            delegate?.ListDetailViewController(self, didFinishAdding: list)
        }
    }
    
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text Field Delegate
        textField.delegate = self
        
        // Change title
        if let list = listToEdit {
            title = "Edit List"
            textField.text = list.name
            doneBarButton.isEnabled = true
        } else {
            title = "Add List"
            // Disable done button by default
            doneBarButton.isEnabled = false
        }
        
        // Icon Image
        imageLabel.image = UIImage(named: iconFolder)
        
        // Hide empty cells
        tableView.tableFooterView = UIView()
        
        // Resign Keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        textField.becomeFirstResponder()
        
        // Disable Large Title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    
}

// MARK: - Table view delegate
extension ListDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 100.0
        } else {
            return 44.0
        }
    }
    
}

// MARK: - Icon Picker Delegate
extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func IconPickerViewController(_ controller: IconPickerViewController, didPick IconName: String) {
        imageLabel.image = UIImage(named: IconName)
        iconFolder = IconName
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Text field delegate
extension ListDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringReange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringReange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
