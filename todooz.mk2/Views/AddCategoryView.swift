//
//  AddCategoryView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI

struct AddCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    

    @State var name: String = ""
    @State var description: String = ""
    @State var selectedColor: String = "3380FE"
    @State var selectedIcon: String = "list.bullet"
    
    let colors: [String] = ["F2503F", "FFDB43", "F8A535", "B35AEF", "3380FE", "5857E3", "63D163", "83E7E3", "000000"]
    let icons: [String] = ["list.bullet", "car.fill", "house.fill", "person.fill", "dumbbell.fill", "desktopcomputer", "cart", "dollarsign", "airplane", "cellularbars"]
    
    
    var FormIsInvalid: Bool {
        return name.isEmpty
    }
    
    func addCategory() {
        let newCategory = Category(name: self.name, dscription: self.description, iconColor: self.selectedColor, icon: self.selectedIcon)
        context.insert(newCategory)
        dismiss()
    }
    
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Form {
                    
                    HStack {
                        
                        Image(systemName: selectedIcon)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color(hex: self.selectedColor))
                            .clipShape(Circle())
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                        
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .submitLabel(.next)
                        
                        
                    }
                    
                    Section {
                        TextField("Beschreibung", text: $description,  axis: .vertical)
                            .lineLimit(5...10)
                    }
                    
                    
                    Section {
                        //Color Picker Section
                        Grid() {
                            GridRow {
                                    ForEach(0...4, id: \.self) { index in
                                        Circle()
                                            .foregroundColor(Color(hex: colors[index]))
                                            .frame(width: 40, height: 40)
                                            .overlay(Circle().stroke(Color.gray, lineWidth: colors[index] == selectedColor ? 4 : 0))
                                            .padding(.horizontal, 8)
                                            .padding(.bottom, 10)
                                            .onTapGesture {
                                                selectedColor = colors[index]
                                            }
                                    }
                                
                                
                            }
                            GridRow {
                                ForEach(5...8, id: \.self) { index in
                                    Circle()
                                        .foregroundColor(Color(hex: colors[index]))
                                        .frame(width: 40, height: 40)
                                        .overlay(Circle().stroke(Color.gray, lineWidth: colors[index] == selectedColor ? 4 : 0))
                                        .onTapGesture {
                                            selectedColor = colors[index]
                                        }
                                }
                            }
                            
                            
                        }
                    }
                    
                    
                    
                    
                    Section {
                        //Icon Picker Section
                        Grid() {
                            GridRow {
                                    ForEach(0...5, id: \.self) { index in
                                        
                                        Image(systemName: icons[index])
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color(.systemGray4))
                                            .overlay(Circle().stroke(Color.gray, lineWidth: icons[index] == selectedIcon ? 4 : 0))
                                            .padding(.horizontal, 4)
                                            .clipShape(Circle())
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .onTapGesture {
                                                selectedIcon = icons[index]
                                            }
                                        

                                    }
                            }
                            
                            GridRow {
                                    ForEach(6...9, id: \.self) { index in
                                        
                                        Image(systemName: icons[index])
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color(.systemGray4))
                                            .overlay(Circle().stroke(Color.gray, lineWidth: icons[index] == selectedIcon ? 4 : 0))
                                            .padding(.horizontal, 4)
                                            .clipShape(Circle())
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .onTapGesture {
                                                selectedIcon = icons[index]
                                            }
                                        

                                    }
                            }
                  
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                        
                    } label: {
                        Text("abbrechen")
                            .foregroundColor(Color(hex: accentColor))
                    }
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Neue Kategorie")
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        addCategory()
                        dismiss()
                        
                    } label: {
                        Text("hinzufügen")
                            .foregroundColor(Color(hex: accentColor))
                    }
                    .disabled(FormIsInvalid)
                    
                }
                
                
                
            }
            
            
            
            
            
            
        }
        
        
        
    }
}

#Preview {
    AddCategoryView()
}
