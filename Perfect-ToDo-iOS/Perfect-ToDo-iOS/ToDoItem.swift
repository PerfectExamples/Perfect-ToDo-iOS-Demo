//
//  ToDoItem.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/17/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation

public class ToDoItem {
    
    private var _id: Int
    private var _item: String
    private var _due: Date?
    private var _completed: Bool
    
    public var id: Int {
        get {
            return _id
        }
    }
    
    public var item: String {
        get {
            return _item
        }
    }
    
    public var due: Date? {
        get {
            return _due
        }
    }
    
    public var completed: Bool {
        return _completed
    }
    
    init(withID id: Int, itemName item: String, dueOn date: Date?) {
        _id = id
        _item = item
        _due = date
        _completed = false
    }
    
    public func setComplete() {
        self._completed = true
    }
    
    public func setIncomplete() {
        self._completed = false
    }
    
    public func changeName(to newName: String) {
        self._item = newName
    }
    
    public func changeDueDate(to dueDate: Date?) {
        self._due = dueDate
    }

}
