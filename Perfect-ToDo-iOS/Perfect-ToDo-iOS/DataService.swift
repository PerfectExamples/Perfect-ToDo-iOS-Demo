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

    fileprivate var _loadedItems = [ToDoItem]()
    fileprivate var _currentUser: RemoteUser?
    
    var loadedItems: [ToDoItem] {
        get {
            return _loadedItems
        }
    }
    
    func add(withItemName item: String, withDueDate due: Date?) {
        let urlPath = "\(apiEndpoint)/v1/create"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        if let token = _currentUser?.currentToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        }
        
        var json = ["item": "\(item)"]
        if let dueDate = due {
            json["dueDate"] = "\(getSQLDateTime(dueDate))"
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = data
        } catch {
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let err = error {
                NotificationCenter.default.post(Notification(name: .apiServerUnreachable))
              debugPrint(urlPath, err.localizedDescription)
            }
            
            do {
                guard let data = data else {
                    return
                }
                guard let jsonArr = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }
                
                
                if let error = jsonArr["error"] {
                    print("An error occurred: \(error)")
                    NotificationCenter.default.post(Notification(name: .addFailure))
                } else if let id = jsonArr["id"] as? Int, let name = jsonArr["item"] as? String, let dueDate = jsonArr["dueDate"] as? String {
                    let due = self.getDate(fromSQLDateTime: dueDate)
                    let todo = ToDoItem(withID: id, itemName: name, dueOn: due)
                    self._loadedItems.append(todo)
                    NotificationCenter.default.post(Notification(name: .addSuccessful))
                }
            } catch let err as NSError {
                print(err.debugDescription)
                NotificationCenter.default.post(Notification(name: .addFailure))
            }
            }.resume()
    }
    
    func update(itemAtIndex index: Int, completed: Bool?, dueDate: Date?, newTitle name: String?) {
        //Trigger API Update
        let id = _loadedItems[index].id
        
        if completed == true {
            self._loadedItems[index].setComplete()
        } else if completed == false {
            self._loadedItems[index].setIncomplete()
        }
        
        self.updateServer(itemWithID: id, completed: completed, dueDate: dueDate, newTitle: name)
        
        NotificationCenter.default.post(Notification(name: .itemUpdated))
    }
    
    func updateServer(itemWithID id: Int, completed: Bool?, dueDate: Date?, newTitle name: String?) {
        let urlPath = "\(apiEndpoint)/v1/update"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        if let token = _currentUser?.currentToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        }
        
        var json = ["id": "\(id)"]
        if let dueDate = dueDate {
            json["dueDate"] = "\(getSQLDateTime(dueDate))"
        }
        if let newName = name {
            json["title"] = newName
        }
        if let isComplete = completed {
            json["completed"] = "\(isComplete)"
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = data
        } catch {
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
                
                
                if let error = jsonArr["error"] {
                    print("An error occurred: \(error)")
                    NotificationCenter.default.post(Notification(name: .updateFailure))
                }
            } catch let err as NSError {
                print(err.debugDescription)
                NotificationCenter.default.post(Notification(name: .updateFailure))
            }
            }.resume()
    }
    
    func remove(at index: Int) {
        //Trigger API removal
        let id = _loadedItems[index].id
        self.deletefromServer(id)
        self._loadedItems.remove(at: index)
    }
    
    func load(forUsername user: String, withPassword password: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(DataService.instance.downloadRemoteServer), name: .tokenSet, object: nil)
        _currentUser = RemoteUser(user: user, pass: password)
        if _currentUser?.currentToken == nil || _currentUser?.currentToken == "" {
            _currentUser?.login()
        }
    }
    
    func deletefromServer(_ id: Int) {
        //Delete From Server
        let urlPath = "\(apiEndpoint)/v1/delete"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        if let token = _currentUser?.currentToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        }
        
        let json = ["id": "\(id)"]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = data
        } catch {
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
                
                
                if let error = jsonArr["error"] {
                    print("An error occurred: \(error)")
                } else if let id = jsonArr["id"] as? Int, let delete = jsonArr["deleted"] as? Bool {
                    if delete == true {
                        print("Deleted Item: \(id): \(delete)")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
            }.resume()
    }
    
    func updateRemoteServer() -> Bool {
        for item in _loadedItems {
            print(item.item) //Placehodler, really push to remote
        }
        
        return true
    }
    
    @objc func downloadRemoteServer() {
        let urlPath = "\(apiEndpoint)/v1/get/all"
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

                            if let complete = json["completed"] as? Bool {
                                if complete == true {
                                    item.setComplete()
                                }
                            }
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
    
    func getSQLDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return formatter.string(from: date)
    }
}
