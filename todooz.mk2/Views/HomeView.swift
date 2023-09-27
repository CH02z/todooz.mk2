//
//  HomeView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @Query(filter: #Predicate<Tasc> { $0.isDone == false }) private var allTascs: [Tasc]
    
    @State private var showAddCategorySheet: Bool = false
    @State private var showSearchResultSheet: Bool = false
    
    @State private var searchQuery = ""
    
    @State private var navigationTitle = "Tasks"
    
    var filteredItems: [Tasc] {
        if searchQuery.isEmpty { return allTascs }
        
        let filteredTascs = allTascs.compactMap { tasc in
            let titleContainsQuery = tasc.title.range(of: searchQuery, options: .caseInsensitive) != nil
            let categoryTitleContainsQuery = tasc.category?.name.range(of: searchQuery, options: .caseInsensitive) != nil
            return (titleContainsQuery || categoryTitleContainsQuery) ? tasc : nil
        }
        
        return filteredTascs
        
    }
    
    struct ViewOffsetKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
    
    var body: some View {
        NavigationStack {
            
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    
                    if searchQuery != "" {
                        
                        if filteredItems.count > 0 {
                            Text("\(filteredItems.count) Resultate")
                                .foregroundColor(.secondary)
                                .padding(.top)
                                .padding(.leading, 25)
                            List {
                                ForEach(filteredItems) {tasc in
                                    NavigationLink(destination: TasklistView(selectedCategory: tasc.category!, taskListType: "category")) {
                                        searchResultTaskRow(tasc: tasc)
                                    }
                                }
                                .presentationDetents([.height(200), .medium, .large])
                                .presentationDragIndicator(.automatic)
                            }
                            .frame(minHeight: 700)
                        } else {
                            Text("Keine Suchergebnisse")
                                .foregroundColor(.secondary)
                                .padding(.top)
                        }
                        
                    } else {
                        
                        Spacer()
                        StandardCategoryPreviewView()
                            .padding()
                        FlaggedTasklistView()
                            .padding()
                        Text("Meine Kategorien")
                            .padding(.leading)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        CategoryListView()
                        
                        
                        
                        
                    }
                    
                    
                }
                .background(
                    GeometryReader {proxy in
                        let offset = proxy.frame(in: .named("scroll")).minY
                        Color.clear.preference(
                            key: ViewOffsetKey.self,
                            value: offset
                        )
                        
                        
                    })
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    
                    DispatchQueue.main.async {
                        self.navigationTitle = value < 125 ? "" : "Tasks"
                        }
                }
                
            }
            
            
            
            
            .sheet(isPresented: $showAddCategorySheet) {
                AddCategoryView()
                    .interactiveDismissDisabled()
            }
            
            
            .navigationTitle(navigationTitle)
            .searchable(text: $searchQuery, prompt: "Tasks durchsuchen")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 5) {
                        Text(Date().format("dd."))
                            .foregroundColor(Color(hex: accentColor))
                        
                        Text(Date().format("MMMM"))
                            .foregroundColor(.secondary)
                        
                        Text(Date().format("YYYY"))
                            .foregroundColor(.secondary)
                        
                    }
                    
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                    
                }
                
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        self.showAddCategorySheet.toggle()
                        
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
                
                
            }
            
            
        }
        
    }
}

#Preview {
    HomeView()
        .modelContainer(previewContainer)
}

