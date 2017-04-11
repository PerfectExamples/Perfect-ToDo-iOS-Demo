//
//  User.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/18/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RemoteUser {
    private var _username: String
    private var _password: String
    private var _currentToken: String? {
        didSet {
            print("Token was Set: \(String(describing: _currentToken))")
            NotificationCenter.default.post(Notification(name: .tokenSet))
        }
    }
    
    var currentToken: String? {
        get {
            return _currentToken
        }
    }
    
    init(user: String, pass: String) {
        _username = user
        _password = pass
    }
    
    func login() {
        
        print("Logging in user: \(_username) with password: \(_password)")
        
        let urlPath = "\(apiEndpoint)/v1/login/?username=\(_username)&password=\(_password)"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.timeoutInterval = 3
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                NotificationCenter.default.post(Notification(name: .apiServerUnreachable))
            }
            
            do {
                guard let data = data else {
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    return
                }
                
                if let token = json["token"] as? String {
                    self._currentToken = token
                } else {
                    if let _ = json["error"] as? String {
                        NotificationCenter.default.post(Notification(name: .invalidLogin))
                    }
                }
            } catch {
                print("Failed to parse JSON Response from Login")
                NotificationCenter.default.post(Notification(name: .invalidLogin))
            }
            }.resume()
    }
    
    func register() {
            
        print("Registering user: \(_username) with password: \(_password)")
        
        let urlPath = "\(apiEndpoint)/v1/register"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.timeoutInterval = 3
        request.httpMethod = "POST"
        request.httpBody = "username=\(_username)&password=\(_password)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                NotificationCenter.default.post(Notification(name: .apiServerUnreachable))
            }
            
            do {
                guard let data = data else {
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    return
                }
                
                if let registration = json["login"] as? String {
                    if registration == "ok" {
                        NotificationCenter.default.post(Notification(name: .userRegistered))
                    }
                } else if let err = json["error"] as? String {
                    if err != "none" {
                        NotificationCenter.default.post(Notification(name: .usernameTaken))
                    }
                } else {
                    NotificationCenter.default.post(Notification(name: .userRegistrationFailed))
                }
            } catch {
                print("Failed to parse JSON Reponse from Registration")
                NotificationCenter.default.post(Notification(name: .userRegistrationFailed))
            }
            }.resume()
    }
   
// Preparation for a Better World in Which We Have Time to Polish Apps
//    func saveCurrentUser() {
//        
//        deleteStoredUsers()
//        
//        let context = getContext()
//        let entity = NSEntityDescription.entity(forEntityName: "StoredUser", in: context)!
//        let user = NSManagedObject(entity: entity, insertInto: context)
//        
//        user.setValue(_username, forKey: "username")
//        user.setValue(_password, forKey: "password")
//        user.setValue(_currentToken, forKey: "currentToken")
//        
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//    
//    func deleteStoredUsers() {
//        let fetchRequest: NSFetchRequest<StoredUser> = StoredUser.fetchRequest()
//        
//        do {
//            let results = try getContext().fetch(fetchRequest)
//            for result in results {
//                getContext().delete(result)
//            }
//        } catch let error as NSError {
//            print(error.debugDescription)
//        }
//    }
//    
//    func fetchSavedUser() {
//        let fetchRequest: NSFetchRequest<StoredUser> = StoredUser.fetchRequest()
//        
//        do {
//            //go get the results
//            let results = try getContext().fetch(fetchRequest)
//            if !results.isEmpty {
//                if let user = results[0].username, let pass = results[0].password {
//                    _username = user
//                    _password = pass
//                }
//                if let token = results[0].currentToken {
//                    _currentToken = token
//                }
//            }
//        } catch {
//            print("Error with request: \(error)")
//        }
//    }
//    
//    func getContext () -> NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
}
