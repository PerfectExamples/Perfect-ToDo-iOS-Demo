//
//  ToDoItems.swift
//  ToDO-Backend
//
//  Created by Ryan Collins on 1/13/17.
//
//

import Foundation
import ToDoModel
import SwiftSQL

struct Items {
    
    func count(forToken token: String) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do {
            let count = try ToDoManager().count(forToken: token)
            let data: [String: Any] = ["count": count]
            response = try data.jsonEncodedString()
        } catch {
            response = "{\"error\": \"Failed to Count Items\"}"
        }
        
        return response
    }
    
    func create(name: String, dueDate: Date?, forToken token: String) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do  {
            let newItem = try ToDoManager().create(item: name, dueDate: dueDate, forToken: token)
            let json: [String: Any] = ["item": "\(newItem.item)", "dueDate": newItem.dueDate == nil ? "NULL" : "\(newItem.dueDate!.sqlDateTime())", "id": newItem.id]
            response = try json.jsonEncodedString()
        } catch {
            
        }
        
        return response
    }
    
    func update(item obj: ToDoItem, completed: Bool?, dueDate: Date?, newName name: String?) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do {
            let updatedItem = try ToDoManager().update(item: obj, completed: completed, dueDate: dueDate, newName: name)
            let json: [String: Any] = ["item": "\(updatedItem.item)", "dueDate": "\(updatedItem.dueDate)", "id": updatedItem.id, "completed": updatedItem.isCompleted]
            response = try json.jsonEncodedString()
        } catch {
            response = "{\"error\": \"Failed to Update\"}"
        }
        
        return response
    }
    
    func getAll(forToken token: String) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do {
            let items = try ToDoManager().get(forToken: token)
            var json: [String: Any] = [String: Any]()
            var itemList = [[String: Any]]()
            for item in items {
                itemList.append(["item": "\(item.item)", "dueDate": item.dueDate == nil ? "NULL" : "\(item.dueDate!.sqlDateTime())", "id": item.id, "completed": item.isCompleted])
            }
            json["todos"] = itemList
            response = try json.jsonEncodedString()
        } catch {
            response = "{\"error\": \"Failed to get\"}"
        }
        
        return response
    }
    
    func delete(_ obj: ToDoItem) -> String {
       var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do {
            let deleted = try ToDoManager().delete(obj)
            let json: [String: Any] = ["id": obj.id, "deleted": deleted]
            response = try json.jsonEncodedString()
        } catch {
            response = "{\"error\": \"Failed to Update\"}"
        }
        
        return response
    }
    
}
