//
//  ToDoItems.swift
//  ToDO-Backend
//
//  Created by Ryan Collins on 1/13/17.
//
//

import Foundation
import ToDoModel

struct Items {
    
    func count() -> String {
        var response = "{\"Error\": \"An Unknown Error Occured\"}"
        
        do {
            let count = try ToDoManager().count()
            let data: [String: Any] = ["count": count]
            response = try data.jsonEncodedString()
        } catch {
            response = "{\"Error\": \"Failed to Count Items\"}"
        }
        
        return response
    }
    
    func create(name: String, dueDate: Date?) -> String {
        var response = "{\"Error\": \"An Unknown Error Occured\"}"
        
        do  {
            let newItem = try ToDoManager().create(item: name, dueDate: dueDate)
            let json: [String: Any] = ["item": "\(newItem.item)", "dueDate": "\(newItem.dueDate)", "id": newItem.id]
            response = try json.jsonEncodedString()
        } catch {
            
        }
        
        return response
    }
    
    func update(item obj: ToDoItem, completed: Bool?, dueDate: Date?, newName name: String?) -> String {
        var response = "{\"Error\": \"An Unknown Error Occured\"}"
        
        do {
            let updatedItem = try ToDoManager().update(item: obj, completed: completed, dueDate: dueDate, newName: name)
            let json: [String: Any] = ["item": "\(updatedItem.item)", "dueDate": "\(updatedItem.dueDate)", "id": updatedItem.id, "completed": updatedItem.isCompleted]
            response = try json.jsonEncodedString()
        } catch {
            response = "{\"Error\": \"Failed to Update\"}"
        }
        
        return response
    }
    
    func getAll() -> String {
        var response = "{\"Error\": \"An Unknown Error Occured\"}"
        
        do {
            let items = try ToDoManager().getAll()
            var json: [[String: Any]] = [[String: Any]]()
            for item in items {
                json.append(["item": "\(item.item)", "dueDate": item.dueDate == nil ? "NULL" : "\(item.dueDate!)", "id": item.id, "completed": item.isCompleted])
            }
            response = try json.jsonEncodedString()
        } catch {
            response = "{\"Error\": \"Failed to Update\"}"
        }
        
        return response
    }
    
    func delete(_ obj: ToDoItem) -> String {
       var response = "{\"Error\": \"An Unknown Error Occured\"}"
        
        do {
            let deleted = try ToDoManager().delete(obj)
            let json: [String: Any] = ["id": obj.id, "deleted": deleted]
            response = try json.jsonEncodedString()
        } catch {
            response = "{\"Error\": \"Failed to Update\"}"
        }
        
        return response
    }
    
}
