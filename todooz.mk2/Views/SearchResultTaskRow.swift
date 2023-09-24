//
//  SearchResultTaskRow.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 24.09.23.
//


import SwiftUI

struct searchResultTaskRow: View {
    
    let tasc: Tasc
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(tasc.title)
                .font(.body)
                .fontWeight(.semibold)
                //.strikethrough(isStrikeThrough)
            
        
            Text(tasc.category!.name)
                    .foregroundColor(Color(.secondaryLabel))
            
          
        }
        
    }
    
}



#Preview {
    ModelPreview { tasc in
        searchResultTaskRow(tasc: tasc)
    }
}
