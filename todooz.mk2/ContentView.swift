//
//  ContentView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 22.09.23.
//

import SwiftUI

struct ContentView: View {
    
    //@State private var currentTab: String = "Home"
    @State private var showNotificationDeniedAlert : Bool = false
    
    var body: some View {
        HomeView()
            .onAppear() {
                
                NotificationHandler.shared.requestPermission(onDeny: {
                    self.showNotificationDeniedAlert.toggle()
                })
            }
            .alert(isPresented : $showNotificationDeniedAlert){
                
                Alert(title: Text("Notification has been disabled for this app"),
                      message: Text("Please go to settings to enable it now"),
                      primaryButton: .default(Text("Go To Settings")) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],
                                                  completionHandler: nil)
                    }
                },
                      secondaryButton: .cancel())
            }
    }
}

#Preview {
    ContentView()
}
