//
//  Category.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI
import SwiftData

@Model
class Category {
    
    var name: String
    var dscription: String
    var iconColor: String
    var icon: String
    var dateCreated: Date
    
    //If Category is deleted, all its Tascs are also deleted
    @Relationship(deleteRule: .cascade, inverse: \Tasc.category)
    var tasks: [Tasc]?
    
   
    
    init(name: String,
         dscription: String,
         iconColor: String,
         icon: String,
         dateCreated: Date = Date(),
         tasks: [Tasc]? = nil
    ) {
        self.name = name
        self.dscription = dscription
        self.iconColor = iconColor
        self.icon = icon
        self.dateCreated = dateCreated
        self.tasks = tasks
    }
}
