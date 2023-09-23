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
        TabView(selection: $currentTab) {
            
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
        }
    }
}

#Preview {
    ContentView()
}
