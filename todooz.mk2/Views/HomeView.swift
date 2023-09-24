//
//  HomeView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI

struct HomeView: View {
    
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @State private var showAddCategorySheet: Bool = false
    
    
    var body: some View {
        NavigationStack {
            
            VStack {
                StandardCategoryPreviewView()
                    .padding()
                Spacer()
                
                CategoryListView()
                
                
                
                
                
                
                
                
            }
            .sheet(isPresented: $showAddCategorySheet) {
                AddCategoryView()
                    .interactiveDismissDisabled()
            }
            
            
            .navigationTitle("Tasks")
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
                    NavigationLink(destination: Text("Profile View")) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 25))
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
                            .font(.system(size: 25))
                        
                    }
                    
                }
                
                
            }
            
            
        }
        
    }
}

#Preview {
    HomeView()
        .modelContainer(modelCategoryPreviewContainer)
}

