//
//  PrewieSampleData.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import Foundation
import SwiftData
import SwiftUI

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


let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Category.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        Task { @MainActor in
            
            let context = container.mainContext
            context.insert(Category.exampl1())
            context.insert(Category.example2())
            context.insert(Tasc.exampl1())
            
        }
        
        return container
    } catch {
        fatalError("Failed to create container: \(error.localizedDescription)")
    }
}()


public struct ModelPreview<Model: PersistentModel, Content: View>: View {
    var content: (Model) -> Content
    
    public init(@ViewBuilder content: @escaping (Model) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        PreviewContentView(content: content)
            .modelContainer(previewContainer)
    }
    
    struct PreviewContentView: View {
        var content: (Model) -> Content
        
        @Query private var models: [Model]
        @State private var waitedToShowIssue = false
        
        var body: some View {
            if let model = models.first {
                content(model)
            } else {
                ContentUnavailableView {
                    Label {
                        Text(verbatim: "Could not load model for previews")
                    } icon: {
                        Image(systemName: "xmark")
                    }
                }
                .opacity(waitedToShowIssue ? 1 : 0)
                .task {
                    Task {
                        try await Task.sleep(for: .seconds(1))
                        waitedToShowIssue = true
                    }
                }
            }
        }
    }
}


