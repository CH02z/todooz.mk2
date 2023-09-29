//
//  TaskRowView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 24.09.23.
//

import SwiftUI
import WidgetKit

struct DoneTaskRowView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @Bindable var tasc: Tasc
    
    @State var isStrikeThrough: Bool = true

    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(tasc.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .strikethrough(isStrikeThrough)
              
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
                        //reload WIdget
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    
                    
                    
                }
            
            
        }
        .frame(height: 40)
        
    }
}


#Preview {
    ModelPreview { tasc in
        DoneTaskRowView(tasc: tasc)
    }
}

