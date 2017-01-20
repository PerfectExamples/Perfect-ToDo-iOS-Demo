//
//  ToDoManager.swift
//  ToDO-Backend
//
//  Created by Ryan Collins on 1/13/17.
//
//

import Foundation
import SwiftSQL
import PerfectTurnstileMySQL

public struct ToDoManager {
    
    public init() {  }
    
    public func get(forToken token: String) throws -> [ToDoItem] {
        var items = [ToDoItem]()
        
        let getObj = ToDoItem()
        
        do {
            let user = try getUser(forToken: token)
            try getObj.select(whereclause: "associatedUser = ?", params: [user], orderby: ["id"])
            
            for row in getObj.rows() {
                items.append(row)
            }
        } catch {
            throw error
        }
        
        return items
    }
    
    public func get(forID id: Int) throws -> ToDoItem {
        let obj = ToDoItem()
        
        do {
            try obj.get(id)
        } catch {
            throw error
        }
        
        return obj
    }
    
    public func count(forToken token: String) throws -> Int {
        let obj = ToDoItem()
        var count = 0
        
        do {
            let rows = try obj.sqlRows("SELECT COUNT(*) FROM todo_items WHERE associatedUser = ?", params: [token])
            
            for row in rows {
                if let results = row.data["COUNT(*)"] as? Int {
                    count = results
                }
            }
            
        } catch {
            throw error
        }
        
        return count
    }
    
    public func create(item: String, dueDate: Date?, forToken token: String) throws -> ToDoItem {
        let obj = ToDoItem()
        
        obj.item = item
        
        do {
            try obj.associatedUser = getUser(forToken: token)
        } catch {
            throw error
        }
        
        
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
        
        let objCompletion = obj.isCompleted ? 1: 0
        let objDate = obj.dueDate == nil ? "NULL": getSQLDateTime(obj.dueDate!)
        
        do {
            try obj.update(cols: ["completed", "item", "due"], params: [objCompletion, "\(obj.item)", objDate], idName: "id", idValue: obj.id)
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
    
    func getUser(forToken token: String) throws -> String {
        var user = ""
        
        let obj = AccessTokenStore()
        
        do {
            let rows = try obj.sqlRows("SELECT userid FROM tokens WHERE token LIKE ?", params: [token])
            
            for row in rows {
                if let results = row.data["userid"] as? String {
                    user = results
                }
            }
        } catch {
            throw error
        }
        
        return user
    }
    
}
