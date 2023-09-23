//
//  Tasc.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI
import SwiftData

@Model
class Tasc {
    
    //Non-Optional Properties
    var id: UUID
    var title: String
    
    
    var category: Category?
    var dateCreated: Date
    
    var isDone: Bool
    var isHighPriority: Bool
    var isFlagged: Bool
    
    
    
    //Optional Properties
    var dscription: String
    var dueDate: Date?
    var dateFinished: Date?
    var notificationID: String?
    var reminderUnit: String?
    var reminderValue: Int?
    
    //If Tasc is deleted, all its Subtascs will be removed too
    @Relationship(deleteRule: .cascade, inverse: \Subtasc.tasc)
    var subtasks: [Subtasc]?
    
    init(title: String,
         category: Category,
         dateCreated: Date = Date(),
         isDone: Bool = false,
         isHighPriority: Bool = false,
         isFlagged: Bool = false,
         dscription: String = "",
         dueDate: Date? = nil,
         dateFinished: Date? = nil,
         notificationID: String? = nil,
         reminderUnit: String? = nil,
         reminderValue: Int? = nil,
         subtasks: [Subtasc]? = nil
         
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.dateCreated = dateCreated
        self.isDone = isDone
        self.isHighPriority = isHighPriority
        self.isFlagged = isFlagged
        self.dscription = dscription
        self.dueDate = dueDate
        self.dateFinished = dateFinished
        self.notificationID = notificationID
        self.reminderUnit = reminderUnit
        self.reminderValue = reminderValue
        self.subtasks = subtasks
        
    }
    
}
