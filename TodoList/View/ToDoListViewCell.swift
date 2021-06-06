//
//  TodoListViewCell.swift
//  TodoList
//
//  Created by Amin  on 6/1/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class ToDoListViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    
    func configure(_ item: ToDoList) {
        
        itemLabel.text = item.title
        checkmarkLabel.text = (item.ischecked) ? "☑️" : "⏺"
        itemLabel.attributedText = NSAttributedString(string: item.title, attributes: (item.ischecked) ?  [NSAttributedString.Key.strikethroughStyle: true] : [NSAttributedString.Key.strikethroughStyle: false] )
    }
    
    func checkIfCompleted(_ item: ToDoList) {
        
        if item.ischecked == true {
            checkmarkLabel.text = "⏺"
            itemLabel.attributedText = NSAttributedString(string: item.title, attributes: [NSAttributedString.Key.strikethroughStyle: false])
        } else {
            checkmarkLabel.text = "☑️"
            itemLabel.attributedText = NSAttributedString(string: item.title, attributes: [NSAttributedString.Key.strikethroughStyle: true])
            
        }
        item.isToggle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
