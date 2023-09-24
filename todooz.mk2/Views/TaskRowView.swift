//
//  TaskRowView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 24.09.23.
//

import SwiftUI

struct TaskRowView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @Bindable var tasc: Tasc
    
    @State var isStrikeThrough: Bool = false

    var body: some View {
        HStack {
            
            if tasc.isHighPriority {
                Image(systemName: "exclamationmark")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if tasc.isFlagged {
                Image(systemName: "flag")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if tasc.dueDate != nil && tasc.dueDate!.isPast {
                Image(systemName: "clock.badge.exclamationmark")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if tasc.notificationID != "" {
                Image(systemName: "bell")
                    .foregroundColor(Color.purple)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if tasc.subtasks!.count > 0 {
                Image(systemName: "list.bullet")
                    .foregroundColor(Color.green)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            
            VStack(alignment: .leading) {
                Text(tasc.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .strikethrough(isStrikeThrough)
                
                if tasc.dueDate != nil {
                    Text(tasc.dueDate!.format("dd.MM.yyyy, HH:mm"))
                        .foregroundColor(Color(.secondaryLabel))
                }
              
            }
            
            
            Spacer()
            
            Image(systemName: isStrikeThrough ? "checkmark.circle" : "circle")
                .foregroundColor(Color(hex: accentColor))
                .font(.system(size: 30))
                .onTapGesture {
                    Task { @MainActor in
                        isStrikeThrough.toggle()
                        try await Task.sleep(seconds: 1.0)
                        //Haptic Feedback on remove
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                        tasc.isDone.toggle()
                        isStrikeThrough.toggle()
                    }
                    
                    
                    
                }
            
            
        }
        .frame(height: 40)
        
    }
}


#Preview {
    ModelPreview { tasc in
        TaskRowView(tasc: tasc)
    }
}

