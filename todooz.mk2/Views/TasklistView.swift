//
//  TasklistView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct TasklistView: View {
    
    @Environment(\.modelContext) private var context
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @State private var showAddTaskSheet: Bool = false
    
    @Query(sort: [
        SortDescriptor(\Tasc.dateCreated, order: .forward)
    ], animation: .snappy) private var allTascs: [Tasc]
    
    //InputCategory
    @Bindable var selectedCategory: Category
    
    
    var body: some View {
        NavigationStack {
            
            List {
                
                ForEach(allTascs) {tasc in
                    HStack {
                        Text(tasc.title)
                        Text(tasc.category!.name)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            //Haptic Feedback on Tap
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            context.delete(tasc)
                            
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
                
                
            }
            
            .sheet(isPresented: $showAddTaskSheet) {
                addTaskView(originalCategory: selectedCategory)
                    .interactiveDismissDisabled()
            }
            
            
            .navigationTitle(selectedCategory.name)
            
            
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        self.showAddTaskSheet.toggle()
                        
                    } label: {
                        Image(systemName: "plus")
                        //.font(.system(size: 25))
                        
                    }
                    
                }
                
                
            }
            
            
            
            
            
        }
    }
}




#Preview {
    ModelPreview { category in
        NavigationStack {
            TasklistView(selectedCategory: category)
        }
    }
}
