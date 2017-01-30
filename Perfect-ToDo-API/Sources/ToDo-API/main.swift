//
//  main.swift
//  Perfect-ToDo-API
//
//  Created by Ryan Collins on 1/10/17.
//
//  Modified from the Perfect Template Project

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import ToDoModel
import MySQLStORM
import StORM
import PerfectTurnstileMySQL
import TurnstilePerfect

// Create HTTP server.
let server = HTTPServer()

// Register routes and handlers
let authWebRoutes = makeWebAuthRoutes()
let authJSONRoutes = makeJSONAuthRoutes("/api/v1")

// Add the routes to the server.
server.addRoutes(authWebRoutes)
server.addRoutes(authJSONRoutes)

// Set the connection properties for the MySQL Server
// Change to suit your specific environment
MySQLConnector.host		= "127.0.0.1"
MySQLConnector.username	= "perfect"
MySQLConnector.password	= "perfect"
MySQLConnector.database	= "perfect_testing"
MySQLConnector.port		= 3306

// Setup our ToDo Model in the Database and setup table if it doesn't exist
let item = ToDoItem()
try? item.setup()

// Used later in script for the Realm and how the user authenticates.
let pturnstile = TurnstilePerfectRealm()

// Set up the Authentication table if it doesn't exist
let auth = AuthAccount()
try? auth.setup()

// Connect the AccessTokenStore and setup table if it doesn't exist
tokenStore = AccessTokenStore()
try? tokenStore?.setup()

// add routes to be excluded from auth check
var authenticationConfig = AuthenticationConfig()
authenticationConfig.exclude("/api/v1/login")
authenticationConfig.exclude("/api/v1/register")
// add routes to be checked for auth
authenticationConfig.include("/api/v1/count")
authenticationConfig.include("/api/v1/get/all")
authenticationConfig.include("/api/v1/create")
authenticationConfig.include("/api/v1/update")
authenticationConfig.include("/api/v1/delete")

let authFilter = AuthFilter(authenticationConfig)

// Note that order matters when the filters are of the same priority level
server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])

server.setRequestFilters([(authFilter, .high)])

// Setup main API
let routes = Router().makeRoutes()
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
    // Launch the servers based on the configuration data.
    try server.start()
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}

