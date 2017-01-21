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
    
    @IBAction func add(_ sender: Any) {
        
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
        
        dump(item)

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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.instance.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
