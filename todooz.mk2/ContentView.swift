//
//  ContentView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentTab: String = "Home"
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
}
