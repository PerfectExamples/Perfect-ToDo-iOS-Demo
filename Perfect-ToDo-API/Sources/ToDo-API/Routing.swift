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
            
            if let authHeader = request.header(.authorization) {
                if let token = self.parseToken(fromHeader: authHeader) {
                    response.setHeader(.contentType, value: "application/json")
                    response.appendBody(string: Items().count(forToken: token))
                    response.completed()
                }
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: "{\"error\": \"failed to count for user\"}")
            response.completed()
            
        })
        
        routes.add(method: .post, uri: "/api/v1/create", handler: {
            request, response in
            
            var responder = "{\"Error\"}"
            
            if let authHeader = request.header(.authorization) {
                if let token = self.parseToken(fromHeader: authHeader) {
            
                    do {
                        if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                            let name = json["item"]
                            let dueDuate = json["dueDate"]
                            let date = getDate(fromSQLDateTime: dueDuate ?? "")
                            
                            if let hasName = name {
                                responder = Items().create(name: hasName, dueDate: date, forToken: token)
                            }
                        }
                        
                    } catch {
                        responder = "{\"error\": \"Failed to create\"}"
                    }
                    
                    response.setHeader(.contentType, value: "application/json")
                    response.appendBody(string: responder)
                    response.completed()
                    
                }
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: "{\"error\": \"failed to create for user\"}")
            response.completed()
            
        })
        
        routes.add(method: .post, uri: "/api/v1/update", handler: {
            request, response in
            
            var responder = "{\"error\"}"
            
            do {
                if let json = try request.postBodyString?.jsonDecode() as? [String: String] {
                    if let id = Int(json["id"]!) {
                        
                        let complete = json["completed"] == "true" ? true : false
                        let due = getDate(fromSQLDateTime: json["dueDate"] ?? "")
                        
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
            
            var responder = "{\"error\"}"
            
            if let authHeader = request.header(.authorization) {
                if let token = self.parseToken(fromHeader: authHeader) {
                    
                    responder = Items().getAll(forToken: token)
                    
                    response.setHeader(.contentType, value: "application/json")
                    response.appendBody(string: responder)
                    response.completed()
                }
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: "{\"error\": \"failed to get the items for user\"}")
            response.completed()
        })
        
        return routes
        
    }
    
    func parseToken(fromHeader header: String) -> String? {
        let bearer = "Bearer "
        if let range = header.range(of: bearer) {
          return header.replacingCharacters(in: range, with: "")
        } else {
            return nil
        }
        
    }
}
 
