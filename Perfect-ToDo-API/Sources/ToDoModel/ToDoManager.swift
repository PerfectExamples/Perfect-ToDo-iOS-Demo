//
//  ToDoManager.swift
//  ToDO-Backend
//
//  Created by Ryan Collins on 1/13/17.
//
//

import Foundation
import SwiftSQL

public struct ToDoManager {
    
    public func getAll() throws -> [ToDoItem] {
        var items = [ToDoItem]()
        
        let getObj = ToDoItem()
        
        do {
            try getObj.select(whereclause: "", params: [], orderby: ["id"])
            
            for row in getObj.rows() {
                items.append(row)
            }
        } catch {
            throw error
        }
        
        return items
    }
    
    public func create(item: String, dueDate: Date?) throws -> ToDoItem {
        let obj = ToDoItem()
        
        obj.item = item
        
        if let due = dueDate {
            obj.setDueDate(due)
        }
        
        do {
            try obj.save {id in obj.id = id as! Int }
        } catch {
            throw error
        }
        
        return obj
    }

    public func update(item obj: ToDoItem, completed: Bool?, dueDate: Date?, newName name: String?) throws -> ToDoItem {
        
        if let complete = completed {
            if complete == true {
                obj.markComplete()
            } else {
                obj.markIncomplete()
            }
        }
        
        if let newName = name {
            obj.item = newName
        }
        
        if dueDate == nil {
            obj.removeDueDate()
        } else {
            obj.setDueDate(dueDate!)
        }
        
//        let objCompletion = obj.isCompleted ? 1: 0
//        let objDate = obj.dueDate == nil ? "NULL": getSQLDateTime(obj.dueDate!)
        
        do {
//            try obj.update(cols: ["completed", "item", "due"], params: [objCompletion, "\(obj.item)", objDate], idName: "id", idValue: obj.id)
            try obj.save()
        } catch {
            throw error
        }
        
        return obj
    }
    
    public func delete(_ obj: ToDoItem) throws -> Bool {
        var deleted = false
        
        do {
            try obj.delete()
            deleted = true
        } catch {
            throw error
        }
        
        return deleted
    }
    
}
