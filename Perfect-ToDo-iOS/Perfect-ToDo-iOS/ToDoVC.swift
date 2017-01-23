//
//  ToDoVC.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/18/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import UIKit

class ToDoVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.onItemsLoaded(_:)), name: .toDoItemsLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onItemsLoaded(_:)), name: .itemUpdated, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func onItemsLoaded(_ notif: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ToDoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.loadedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = DataService.instance.loadedItems[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            cell.configureCell(item)
            return cell
        } else {
            let cell = ItemCell()
            cell.configureCell(item)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let markComplete = UITableViewRowAction(style: .normal, title: "Complete") { action, index in
            DataService.instance.update(itemAtIndex: indexPath.row, completed: true, dueDate: nil, newTitle: nil)
        }
        markComplete.backgroundColor = .green
        
        let markIncomplete = UITableViewRowAction(style: .normal, title: "Incomplete") { action, index in
            DataService.instance.update(itemAtIndex: indexPath.row, completed: false, dueDate: nil, newTitle: nil)
        }
        markIncomplete.backgroundColor = .lightGray
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            DataService.instance.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        delete.backgroundColor = .red
        
        return [markComplete, markIncomplete, delete]
    }
}
