//
//  Subtasc.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI
import SwiftData


struct Subtasc: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var isDone: Bool
}
