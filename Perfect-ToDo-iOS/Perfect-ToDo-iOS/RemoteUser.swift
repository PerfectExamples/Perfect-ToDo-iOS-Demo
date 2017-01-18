//
//  User.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/18/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation

class RemoteUser {
    private var _username: String
    private var _password: String
    private var _currentToken: String?
    
    public var currentToken: String? {
        get {
            return _currentToken
        }
    }
    
    init(user: String, pass: String) {
        _username = user
        _password = pass
    }
    
    func authenticate() {
        
    }
}
