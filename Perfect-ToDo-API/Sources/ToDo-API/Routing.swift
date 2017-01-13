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

struct Router {
    func makeRoutes() -> Routes {
        
        // An example route where authentication will be enforced
        var routes = Routes()
        
        routes.add(method: .get, uri: "/api/v1/check", handler: {
            request, response in
            response.setHeader(.contentType, value: "application/json")
            
            var resp = [String: String]()
            resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
            resp["authDetails"] = "DETAILS: \(request.user.authDetails)"
            
            do {
                try response.setBody(json: resp)
            } catch {
                print(error)
            }
            response.completed()
        })
        
        routes.add(method: .post, uri: "/api/v1/create", handler: {
            request, response in
            
            
        })
        
        return routes
        
    }
}
