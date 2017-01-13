//
//  ToDoModel.swift
//  Perfect-ToDo-Model
//
//  Created by Ryan Collins on 1/13/17.
//  Copyright © 2017 Ryan Collins. All rights reserved.
//

import Foundation
import MySQLStORM
import StORM
import SwiftSQL

public class ToDoItem: MySQLStORM {
    
    public var id: Int = 0
    public var item: String = "Default"
    private var due: String = "NULL"
    private var completed: Int = 0
    
    public var dueDate: Date? {
        get {
            return getDate(fromSQLDateTime: due)
        }
    }
    
    public var isCompleted: Bool {
        get {
            return completed == 1
        }
    }
    
    func markComplete() {
        completed = 1
    }
    
    func markIncomplete() {
        completed = 0
    }
    
    func setDueDate(_ date: Date) {
        due = getSQLDateTime(date)
    }
    
    func removeDueDate() {
        due = "NULL"
    }
    
    override open func table() -> String { return "todo_items" }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        item = this.data["item"] as? String ?? "Default"
        completed = this.data["completed"] as? Int ?? 0
        due = this.data["due"] as? String ?? "NULL"
    }
    
    func rows() -> [ToDoItem] {
        var rows = [ToDoItem]()
        for i in 0..<self.results.rows.count {
            let row = ToDoItem()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
