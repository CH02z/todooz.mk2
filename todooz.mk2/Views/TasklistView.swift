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
    @State var showDetailTaskSheet: Bool = false
    
    @State var detailTasc: Tasc = Tasc(title: "")
    
    //InputCategory
    @Bindable var selectedCategory: Category
    let taskListType: String
    
    @Query(filter: #Predicate<Tasc> { $0.isDone == false },
           sort: [
            SortDescriptor(\Tasc.dateCreated, order: .forward)
           ], animation: .snappy) private var allTascs: [Tasc]
    
    init(selectedCategory: Category, taskListType: String) {
        self.selectedCategory = selectedCategory
        self.taskListType = taskListType
    }
    
    var filteredTascs: [Tasc] {
        let filteredTascs = allTascs.compactMap { tasc in
            
            switch taskListType {
            case "category":
                return (tasc.category == selectedCategory) ? tasc : nil
            case "today":
                if tasc.dueDate != nil {
                    return (tasc.dueDate!.isToday) ? tasc : nil
                } else {
                    return nil
                }
            case "priority":
                return (tasc.isHighPriority) ? tasc : nil
                
            case "flagged":
                return (tasc.isFlagged) ? tasc : nil
            case "overdue":
                if tasc.dueDate != nil {
                    return (tasc.dueDate!.isPast) ? tasc : nil
                } else {
                    return nil
                }
                
            default:
                return tasc
                
            }
            
        }
        return filteredTascs
        
    }
    
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredTascs) {tasc in
                    TaskRowView(tasc: tasc)
                        .swipeActions(edge: .leading) {
                            
                            Button() {
                                tasc.isHighPriority.toggle()
                            } label: {
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                            }
                            .tint(.red)
                            
                            
                            Button() {
                                tasc.isFlagged.toggle()
                            } label: {
                                Image(systemName: "flag")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .tint(.orange)
                            
                            
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
                        .contextMenu {
                            Button {
                                self.detailTasc = tasc
                                self.showDetailTaskSheet = true
                            
                                
                            } label: {
                                Label("Detailansicht", systemImage: "eye")
                                    .foregroundColor(.red)
                            }
                            
                        
                        }
                }
                if filteredTascs.count == 0 {
                        Text("Keine Tasks in dieser Kategorie")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                }
                
                
            }
            
            .sheet(isPresented: $showAddTaskSheet) {
                addTaskView(originalCategory: selectedCategory)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $showDetailTaskSheet, content: {
                DetailTaskView(tasc: $detailTasc)
            })

            
            
            .navigationTitle(selectedCategory.name)
            
            
            .toolbar {
                
                if taskListType == "category" {
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
}




#Preview {
    ModelPreview { category in
        NavigationStack {
            TasklistView(selectedCategory: category, taskListType: "category")
        }
    }
}
