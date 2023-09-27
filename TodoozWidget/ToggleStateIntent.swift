//
//  ToggleStateIntent.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 27.09.23.
//

import Foundation

import SwiftUI
import AppIntents
import SwiftData

struct ToggleStateIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task State"
    
    /// Parameters
    @Parameter(title: "Task ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    @MainActor
    private func getTascByID(id: String) -> Tasc {
        guard let modelContainer = try? ModelContainer(for: Tasc.self) else {
            return Tasc(title: "")
        }
        let predicate = #Predicate<Tasc> { $0.id.uuidString == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        let tascs = try? modelContainer.mainContext.fetch(descriptor)
        return tascs![0] ?? Tasc(title: "")
    }
    
    func perform() async throws -> some IntentResult {
        // UPDATE YOUR DATABASE HERE
        
        var tasc = await getTascByID(id: self.id)
        tasc.isDone.toggle()
        
        
        
       
        return .result()
    }
}
