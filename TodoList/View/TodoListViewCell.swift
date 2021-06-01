//
//  TodoListViewCell.swift
//  TodoList
//
//  Created by Amin  on 6/1/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit

class TodoListViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // Action
    @IBAction func strikeButton(_ sender: Any) {
        
    }
    
    
    func configure(_ item: TodoList) {
        
        itemLabel.text = item.title
        button.setTitle((item.ischecked) ? "☑️" : "⏺" , for: .normal)
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
