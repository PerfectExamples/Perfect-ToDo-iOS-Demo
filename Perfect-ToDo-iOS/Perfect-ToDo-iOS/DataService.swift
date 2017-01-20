//
//  DataService.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/17/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation

class DataService {
    
    static let instance = DataService()

    fileprivate var _loadedItems = [ToDoItem]() {
        didSet {
            NotificationCenter.default.post(Notification(name: .toDoItemsLoaded))
        }
    }
    fileprivate var _currentUser: RemoteUser?
    
    var loadedItems: [ToDoItem] {
        get {
            return _loadedItems
        }
    }
    
    func add() {
        
    }
    
    func load(forUsername user: String, withPassword password: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(DataService.instance.downloadRemoteServer), name: .tokenSet, object: nil)
        _currentUser = RemoteUser(user: user, pass: password)
        if _currentUser?.currentToken == nil || _currentUser?.currentToken == "" {
            _currentUser?.login()
        }
    }
    
    func updateRemoteServer() -> Bool {
        for item in _loadedItems {
            print(item.item) //Placehodler, really push to remote
        }
        
        return true
    }
    
    @objc func downloadRemoteServer() {
        let urlPath = "http://0.0.0.0:8181/api/v1/get/all"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        if let token = _currentUser?.currentToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var items = [ToDoItem]()
            
            if error != nil {
                NotificationCenter.default.post(Notification(name: .apiServerUnreachable))
            }
            
            do {
                guard let data = data else {
                    return
                }
                guard let jsonArr = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }
                
                if let array = jsonArr["todos"] as? [[String: Any]] {
                    for json in array {
                        if let id = json["id"] as? Int, let item = json["item"] as? String {
                            
                            var due: Date? = nil
                            
                            if let dueDate = json["dueDate"] as? String {
                                due = self.getDate(fromSQLDateTime: dueDate)
                            }
                            
                            let item = ToDoItem(withID: id, itemName: item, dueOn: due)
                            items.append(item)
                        }
                    }
                    
                    self._loadedItems = items
                    NotificationCenter.default.post(Notification(name: .downloadComplete))
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
            }.resume()
    }
    
    func getDate(fromSQLDateTime str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return formatter.date(from: str)
    }
}
