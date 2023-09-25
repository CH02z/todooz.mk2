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
    @AppStorage("selectedSortOption") private var selectedSortOption = SortOption.allCases.first!
    
    @State private var showAddTaskSheet: Bool = false
 
    
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
            case "scheduled":
                return (tasc.notificationID != "") ? tasc : nil
                
            default:
                return tasc
                
            }
            
        }
        return filteredTascs.sort(on: selectedSortOption)
        
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
                                NotificationHandler.shared.removeNotifications(ids: [tasc.notificationID ?? ""])
                                context.delete(tasc)
                                
                                
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                        .contextMenu {
                                                       
                            NavigationLink(destination: DetailTaskView(tasc: tasc, subtascs: tasc.subtasks!)) {
                                Text("Detailansicht")
                                Image(systemName: "eye")
                            }
                            
                            
                            
                            NavigationLink(destination: EditTaskView(inputEditTasc: tasc)) {
                                Text("bearbeiten")
                                Image(systemName: "pencil")
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
            
            
            
            .navigationTitle(selectedCategory.name)
            
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases,
                                    id: \.rawValue) { option in
                                Label(option.rawValue.capitalized,
                                      systemImage: option.systemImage)
                                .tag(option)
                            }
                        }
                        .labelsHidden()
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                    }
                    
                }
                
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
                
                
                
                if filteredTascs.count > 0 {
                    ToolbarItem(placement: .principal) {
                        Text("\(filteredTascs.count) Tasks")
                            .padding(.leading)
                            .foregroundColor(.secondary)
                    }
                    
                }
                
                
                
                
                
                
            }
            
            
            
            
            
        }
        
        
        
        
    }
}

private extension [Tasc] {
    
    func sort(on option: SortOption) -> [Tasc] {
        switch option {
        case .title:
            self.sorted(by: { $0.title < $1.title })
        case .date:
            self.sorted(by: { $0.dateCreated < $1.dateCreated })
        }
    }
}

enum SortOption: String, CaseIterable {
    case title
    case date
}

extension SortOption {
    
    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .date:
            "calendar"
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
