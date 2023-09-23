//
//  Subtasc.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI
import SwiftData

@Model
class Subtasc {
    var id: UUID
    var title: String
    var isDone: Bool
    
    var tasc: Tasc
   
    
    init(title: String, isDone: Bool = false, tasc: Tasc) {
        self.id = UUID()
        self.title = title
        self.isDone = isDone
        self.tasc = tasc
    }
}
