//
//  CustomNotifications.swift
//  Perfect-ToDo-iOS
//
//  Created by Ryan Collins on 1/19/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let tokenSet = Notification.Name("tokenSet")
    static let downloadComplete = Notification.Name("downloadComplete")
    static let toDoItemsLoaded = Notification.Name("toDoItemsLoaded")
    static let invalidLogin = Notification.Name("invalidLogin")
}
