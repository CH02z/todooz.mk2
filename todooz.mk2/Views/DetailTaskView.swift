//
//  DetailTaskView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 24.09.23.
//

import SwiftUI

struct DetailTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @Binding var tasc: Tasc
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                
                Text(tasc.title)
                    .font(.title2)
                //.font(.system(size: 28))
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
                
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                                
                            } label: {
                                Text("schliessen")
                                    .foregroundColor(Color(hex: accentColor))
                            }
                            
                        }
                    }
                
                if tasc.subtasks!.count > 0 {
                    List {
                        ForEach(tasc.subtasks!, id: \.self) { sbtask in
                            HStack {
                                Text(sbtask.title)
                                    .strikethrough(sbtask.isDone)
                                Spacer()
                                Image(systemName: sbtask.isDone ? "checkmark.circle" : "circle")
                                    .foregroundColor(Color(hex: accentColor))
                                    .font(.system(size: 25))
                            }.onTapGesture {
                                //Haptic Feedback on Tap
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                                
                                
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


