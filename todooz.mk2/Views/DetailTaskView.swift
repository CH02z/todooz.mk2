//
//  DetailTaskView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 24.09.23.
//

import SwiftUI

struct DetailTaskView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var tasc: Tasc
    
    @State var subtascs: [Subtasc]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                
                Text(tasc.title)
                    .font(.title2)
                    .strikethrough(tasc.isDone)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 40) {
                    Label("\(tasc.category!.name)", systemImage: "list.bullet")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    if tasc.dueDate != nil {
                        Label("\(tasc.dueDate!.format("dd.MM.yyyy, HH:mm"))", systemImage: "calendar")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    
                }
                
                if tasc.notificationID != "" {
                    Label("\(tasc.reminderValue!) \(tasc.reminderUnit!) vorher", systemImage: "bell")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                Text(tasc.dscription)
                    .font(.body)
                    .padding()
                
                
                if tasc.subtasks!.count > 0 {
                    
                    List {
                        ForEach($subtascs, id: \.self) { $sbtask in
                            
                            
                            HStack {
                                Text(sbtask.title)
                                    .strikethrough(sbtask.isDone)
                                Spacer()
                                Image(systemName: sbtask.isDone ? "checkmark.circle" : "circle")
                                    .foregroundColor(Color(hex: accentColor))
                                    .font(.system(size: 25))
                                    .onTapGesture {
                                        Task { @MainActor in
                                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                            impactHeavy.impactOccurred()
                                            
                                            sbtask.isDone = true
                                            
                                            try await Task.sleep(seconds: 1.0)
                                            //Haptic Feedback on remove
                                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                                            impactLight.impactOccurred()
                                            
                                            let newSubtascs = self.subtascs.filter({ subtasc in
                                                if subtasc.id != sbtask.id {
                                                    return true
                                                } else {
                                                    return false
                                                    
                                                }
                                            })
                                            self.subtascs = newSubtascs
                                            withAnimation {
                                                tasc.subtasks = newSubtascs
                                            }
                                            
                                            if tasc.subtasks!.count == 0 {
                                                Task { @MainActor in
                                                    tasc.isDone.toggle()
                                                    try await Task.sleep(seconds: 1.0)
                                                    dismiss()
                                                    
                                                }
                                                
                                            }
                                            
                                            
                                        
                                            
                                            
                                        }
                                
                                    }
                            }
                        }
                    }
                    .padding(.top, 50)
                    
                    
                    
                }
                Spacer()
      
            }
            
        }
    }
}



