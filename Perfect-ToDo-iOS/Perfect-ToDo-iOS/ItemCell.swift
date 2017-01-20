//
//  ItemCell.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/19/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(_ item: ToDoItem) {
        self.itemName.text? = item.item
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if let date = item.due {
            self.dueDate.text? = "Due: " + formatter.string(from: date)
        } else {
            self.dueDate.text? = ""
        }
    }
}
