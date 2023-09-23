//
//  StandardCategoryPreviewView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI

struct StandardCategoryPreviewView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    
    var body: some View {
        VStack {
            
            //Today Section-------------------------------------------------------------------
            HStack {
                NavigationLink(destination: Text("TodayTasks")) {
                    HStack {
                        VStack {
                            Image(systemName: "calendar.circle")
                                .foregroundColor(Color(hex: accentColor))
                                .font(.system(size: 35))
                                //.fontWeight(.semibold)
                                .padding(.vertical, 3.5)
                                .padding(.trailing, 5)
                            
                            Text("Heute")
                                .fontWeight(.semibold)
                        }
                        .padding(.leading, 6)
                        
                        Spacer()
                        Text("0")
                            .padding(.trailing, 6)
                            .font(.title)
                    }
                    .foregroundColor(Color("MainFontColor"))
                    .frame(width: 155, height: 80)
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
                .background(Color("ElementBackround"))
                .cornerRadius(10)
                
                Spacer()
                
                //Priority Section------------------------------------------------------------------------------------------------------------
                NavigationLink(destination: Text("Prio")) {
                    HStack {
                        VStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(Color(hex: accentColor))
                                .font(.system(size: 35))
                                //.fontWeight(.semibold)
                                .padding(.vertical, 3.5)
                                .padding(.trailing, 20)
                            
                            
                            Text("Priorität")
                                .fontWeight(.semibold)
                                .padding(.leading, 6)
                        }
                        .frame(alignment: .leading)
                        
                        
                        Spacer()
                        Text("0")
                            .padding(.trailing, 6)
                            .font(.title)
                    }
                    .foregroundColor(Color("MainFontColor"))
                    .frame(width: 155, height: 80)
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
                .background(Color("ElementBackround"))
                .cornerRadius(10)
                
            }
            
            
            //Category Scroll View-----------------------------------------------------------------
            HStack {
                
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 25) {
                        NavigationLink(destination: Text("isDone")) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 25))
                        
                        }
                        .padding(.leading, 15)
                        
                    
                        NavigationLink(destination: Text("flagged")) {
                            Image(systemName: "flag")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 20))
                                
                        }
                        
                        NavigationLink(destination: Text("scheduled")) {
                            Image(systemName: "bell")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 20))
                                
                        }
                        
                        NavigationLink(destination: Text("Overdue")) {
                            Image(systemName: "clock.badge.exclamationmark")
                                .foregroundColor(Color(hex: accentColor))
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray4))
                                .cornerRadius(30)
                                .font(.system(size: 20))
                                
                        }
                        
                    }
            
                }
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .background(Color("ElementBackround"))
            .cornerRadius(10)
            .padding(.top, 10)
            
        }
    }
}

#Preview {
    StandardCategoryPreviewView()
}
