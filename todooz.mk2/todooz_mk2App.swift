//
//  todooz_mk2App.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI

@main
struct todooz_mk2App: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Tasc.self, Category.self])
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .accentColor(Color(hex: accentColor))
        }
    }
}
