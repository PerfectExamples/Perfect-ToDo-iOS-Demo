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
    fileprivate var _currentUser: User?
    
    var loadedItems: [ToDoItem] {
        get {
            return _loadedItems
        }
    }
    
    func add() {
        
    }
    
    func load() {
        
    }
    
    func updateRemoteServer() {
        for item in _loadedItems {
            print(item.item) //Placehodler, really push to remote
        }
    }
    
    func downloadRemoteServer() {
        
    }

}
