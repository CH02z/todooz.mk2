//
//  TasklistView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct FlaggedTasklistView: View {
    
    @Environment(\.modelContext) private var context
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
 

    
    @Query(filter: #Predicate<Tasc> { $0.isDone == false && $0.isFlagged == true },
           sort: [
            SortDescriptor(\Tasc.dateCreated, order: .forward)
           ], animation: .snappy) private var allTascs: [Tasc]
    

    
    
    var body: some View {
        
        if allTascs.count > 0 {
            
            VStack {
                
                ForEach(allTascs) {tasc in
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
                
            }
            
            
            
            
        }
     
    }
}



#Preview {
    FlaggedTasklistView()
        .modelContainer(previewContainer)
}
