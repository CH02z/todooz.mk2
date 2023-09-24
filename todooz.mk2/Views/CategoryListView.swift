//
//  CategoryListView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    
    
    @Environment(\.modelContext) private var context
    @Query(sort: [
        SortDescriptor(\Category.dateCreated, order: .forward)
    ], animation: .snappy) private var allCategories: [Category]
    
    @State private var deleteRequest: Bool = false
    @State private var CategoryToBeDeleted: Category? = nil
    
   
    
    var body: some View {
        
        
        if allCategories.count == 0 {
            VStack {
                Text("Erstelle zuerst eine Kategorie, um neue Tasks hinzuzufügen")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            
        }
        
        
        
        List {
            
            ForEach(allCategories) { category in
                NavigationLink(destination: TasklistView(selectedCategory: category, taskListType: "category")) {
                    CategoryPreviewView(category: category)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                //Haptic Feedback on Tap
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                                deleteRequest.toggle()
                                CategoryToBeDeleted = category
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                }
            }
            
        }
        .alert("If you delete a category, all the associated Tasks will be deleted too.", isPresented: $deleteRequest) {
            Button(role: .destructive) {
                /// Deleting Category
                if let CategoryToBeDeleted {
                    context.delete(CategoryToBeDeleted)
                    self.CategoryToBeDeleted = nil
                }
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                CategoryToBeDeleted = nil
            } label: {
                Text("Cancel")
            }
        }
    }
}


struct CategoryPreviewView: View {
    
    @Query(filter: #Predicate<Tasc> { $0.isDone == false }) private var allTascs: [Tasc]
    
    func getNumberOfTasksInCategory(_ cat: Category) -> Int {
        let filteredTascs = allTascs.compactMap { tasc in
            return (tasc.category == cat) ? tasc : nil
        }
        return filteredTascs.count
    }
    
    @Bindable var category: Category
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color(hex: category.iconColor))
                .clipShape(Circle())
                .font(.system(size: 15))
                .fontWeight(.bold)
                .padding(.trailing, 5)
            //.overlay(Circle().stroke(Color.white, lineWidth: 1))
            
            Text(category.name)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
            
            Text(String(getNumberOfTasksInCategory(category)))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 3.5)
    }
}






#Preview {
    CategoryListView()
        .modelContainer(modelCategoryPreviewContainer)
}
