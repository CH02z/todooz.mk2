//
//  TasklistView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct IsDoneTasklistView: View {
    
    @Environment(\.modelContext) private var context
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"

    
    
    @Query(filter: #Predicate<Tasc> { $0.isDone == true },
           sort: [
            SortDescriptor(\Tasc.dateCreated, order: .forward)
           ], animation: .snappy) private var allTascs: [Tasc]

    
    
    var body: some View {
        NavigationStack {
            
            List {
                
                ForEach(allTascs) {tasc in
                    DoneTaskRowView(tasc: tasc)
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
                if allTascs.count == 0 {
                        Text("Keine Erledigten Tasks")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                }
                
                
            }

            
            
            .navigationTitle("Erledigte Tasks")
            
            
            
            
            
        }
    }
}




#Preview {
    IsDoneTasklistView()
        .modelContainer(previewContainer)
}
