//
//  CustomNotifications.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/19/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation

extension Notification.Name {
    //Global
    static let apiServerUnreachable = Notification.Name("apiServerUnreachable")
    //User
    static let tokenSet = Notification.Name("tokenSet")
    //DataService Loaading
    static let downloadComplete = Notification.Name("downloadComplete")
    static let toDoItemsLoaded = Notification.Name("toDoItemsLoaded")
    //Login
    static let invalidLogin = Notification.Name("invalidLogin")
    //Registration
    static let usernameTaken = Notification.Name("usernameTaken")
    static let userRegistered = Notification.Name("userRegistered")
    static let userRegistrationFailed = Notification.Name("userRegistrationFailed")
    static let registrationSuccess = Notification.Name("registrationSuccess")
    //Adding
    static let addSuccessful = Notification.Name("addSuccessful")
    static let addFailure = Notification.Name("addFailure")
}
