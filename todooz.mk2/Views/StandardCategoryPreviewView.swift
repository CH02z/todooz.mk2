//
//  StandardCategoryPreviewView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct StandardCategoryPreviewView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @Query(filter: #Predicate<Tasc> { $0.isDone == false },
           sort: [
            SortDescriptor(\Tasc.dateCreated, order: .forward)
           ], animation: .snappy) private var allTascs: [Tasc]
    
    var numberOfTodayTasks: Int {
        let filteredTascs = allTascs.compactMap { tasc in
            if tasc.dueDate != nil {
                return (tasc.dueDate!.isToday) ? tasc : nil
            } else {
                return nil
            }
        }
        return filteredTascs.count
    }
    
    var numberOfHighPrioTasks: Int {
        let filteredTascs = allTascs.compactMap { tasc in
            return (tasc.isHighPriority) ? tasc : nil
        }
        return filteredTascs.count
    }
    
    
    
    
    var body: some View {
        VStack {
            
            //Today Section-------------------------------------------------------------------
            HStack {
                NavigationLink(destination: TasklistView(selectedCategory: Category(name: "Heute", dscription: "", iconColor: "", icon: ""), taskListType: "today")) {
                    HStack {
                        VStack {
                            Image(systemName: "calendar.circle")
                                .foregroundColor(Color(hex: accentColor))
                                .font(.system(size: 35))
                                //.fontWeight(.semibold)
                                .padding(.vertical, 3.5)
                                .padding(.trailing, 5)
                            
                            Text("Heute")
                                .fontWeight(.semibold)
                        }
                        .padding(.leading, 6)
                        
                        Spacer()
                        Text(String(numberOfTodayTasks))
                            .padding(.trailing, 6)
                            .font(.title)
                    }
                    .foregroundColor(Color("MainFontColor"))
                    .frame(width: 155, height: 80)
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
                .background(Color("ElementBackround"))
                .cornerRadius(10)
                
                Spacer()
                
                //Priority Section------------------------------------------------------------------------------------------------------------
                NavigationLink(destination: TasklistView(selectedCategory: Category(name: "Hohe Priorität", dscription: "", iconColor: "", icon: ""), taskListType: "priority")) {
                    HStack {
                        VStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(Color(hex: accentColor))
                                .font(.system(size: 35))
                                //.fontWeight(.semibold)
                                .padding(.vertical, 3.5)
                                .padding(.trailing, 20)
                            
                            
                            Text("Priorität")
                                .fontWeight(.semibold)
                                .padding(.leading, 6)
                        }
                        .frame(alignment: .leading)
                        
                        
                        Spacer()
                        Text(String(numberOfHighPrioTasks))
                            .padding(.trailing, 6)
                            .font(.title)
                    }
                    .foregroundColor(Color("MainFontColor"))
                    .frame(width: 155, height: 80)
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
                .background(Color("ElementBackround"))
                .cornerRadius(10)
                
            }
            
            
            //Category Scroll View-----------------------------------------------------------------
            HStack {
                
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 25) {
                        NavigationLink(destination: IsDoneTasklistView()) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 25))
                        
                        }
                        .padding(.leading, 15)
                        
                    
                        NavigationLink(destination: TasklistView(selectedCategory: Category(name: "Markiert", dscription: "", iconColor: "", icon: ""), taskListType: "flagged")) {
                            Image(systemName: "flag")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 20))
                                
                        }
                        
                        NavigationLink(destination: Text("scheduled")) {
                            Image(systemName: "bell")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 20))
                                
                        }
                        
                        NavigationLink(destination: TasklistView(selectedCategory: Category(name: "Überfällig", dscription: "", iconColor: "", icon: ""), taskListType: "overdue")) {
                            Image(systemName: "clock.badge.exclamationmark")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 20))
                                
                        }
                        
                    }
            
                }
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .background(Color("ElementBackround"))
            .cornerRadius(10)
            .padding(.top, 10)
            
        }
    }
}



#Preview {
    StandardCategoryPreviewView()
        .modelContainer(previewContainer)
}
