//
//  AddItemViewController.swift
//  TodoList
//
//  Created by Amin  on 6/1/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit
import UserNotifications


// MARK: - Delegate Protocol
protocol ItemDetailViewControllerDelegate: class {
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoItems)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoItems)
}

// MARK: - Main class
class ItemDetailViewController: UITableViewController {
    
    // Due date variable
    var dueDate = Date()
    var datePickerVisible = false
    
    // Edit Item Variable
    var itemToEdit: ToDoItems?
    
    // Delegate Variable
    weak var delegate: ItemDetailViewControllerDelegate?
    
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    
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
        
        
        // Resign keyboard
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self.view, action: #selector(view.endEditing(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // update due date
        updateDueDateLabel()
        
        
    }
    
    // Active Keyboard Automatically
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.title = textField.text!
            itemToEdit.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit.dueDate = dueDate
            itemToEdit.scheduleNotification()
            delegate?.ItemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ToDoItems()
            item.title = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        
        dueDate = sender.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldReminderToggle(_ sender: UISwitch) {
        
        textField.resignFirstResponder()
        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                (granted, errors) in
                if let error = errors {
                    print("Opps, something went wrong:- \(error.localizedDescription)")
                }
            }
        }
    }
    
    
}

// MARK: - TableView DataSource
extension ItemDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
}



// MARK: - TableView Delegate

extension ItemDetailViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 100.0
        } else if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // Because we use unmber of row in section with static table so we have to override this method
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
}

// MARK: - Helper Methods
extension ItemDetailViewController {
    
    private func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    private func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .automatic)
        datePicker.setDate(dueDate, animated: true)
        dueDateLabel.textColor = dueDateLabel.tintColor
    }
    
    private func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexDatePicker = IndexPath(row: 2, section: 1)
            tableView.deleteRows(at: [indexDatePicker], with: .automatic)
            dueDateLabel.textColor = .black
        }
    }
    
    
}
