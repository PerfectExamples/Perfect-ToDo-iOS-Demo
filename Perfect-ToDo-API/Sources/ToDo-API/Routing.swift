//
//  Routing.swift
//  ToDO-Backend
//
//  Created by Ryan Collins on 1/13/17.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import ToDoModel
import MySQLStORM
import StORM

import SwiftSQL

struct Router {
    func makeRoutes() -> Routes {
        
        var routes = Routes()
        
        routes.add(method: .get, uri: "/api/v1/count", handler: {
            request, response in
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: Items().count())
            response.completed()
        })
        
        routes.add(method: .post, uri: "/api/v1/create", handler: {
            request, response in
            
            var responder = "{\"Error\"}"
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    let name = json["item"]
                    let dueDuate = json["dueDate"]
                    let date = getDate(fromSQLDate: dueDuate ?? "")
                    
                    if let hasName = name {
                        responder = Items().create(name: hasName, dueDate: date)
                    }
                }
                
            } catch {
                responder = "{\"error\": \"Failed to create\"}"
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
        })
        
        routes.add(method: .post, uri: "/api/v1/update", handler: {
            request, response in
            
            var responder = "{\"error\"}"
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    if let id = Int(json["id"]!) {
                        
                        let complete = json["completed"] == "true" ? true : false
                        let due = getDate(fromSQLDate: json["dueDate"] ?? "")
                        
                        var newItemName: String? = nil
                        
                        if let newName = json["item"] {
                            newItemName = newName
                        }
                        
                        let item = try ToDoManager().get(forID: id)
                        responder = Items().update(item: item, completed: complete, dueDate: due, newName: newItemName)
                    }
                }
            } catch {
                responder = "{\"error\": \"Failed to update\"}"
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
        })
        
        routes.add(method: .post, uri: "/api/v1/delete", handler: {
            request, response in
            
            var responder = "{\"error\"}"
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    if let id = Int(json["id"] ?? "0") {
                        let item = try ToDoManager().get(forID: id)
                        responder = Items().delete(item)
                    }
                }
            } catch {
                responder = "{\"error\": \"Failed to delete\"}"
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
        })
        
        routes.add(method: .get, uri: "/api/v1/get/all", handler: {
            request, response in
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: Items().getAll())
            response.completed()
        })
        
        return routes
        
    }
}
 
