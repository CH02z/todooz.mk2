//
//  PrewieSampleData.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import Foundation
import SwiftData

@MainActor
let modelCategoryPreviewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Category.self)
        
      
        container.mainContext.insert(TestData.categories[0])
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()


