//
//  addTaskView.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import SwiftUI
import SwiftData

struct addTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query(sort: [SortDescriptor(\Category.dateCreated, order: .forward)]) private var allCategories: [Category]
    
    
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    //InputCategory
    @State var originalCategory: Category
    @State var newTasc = Tasc(title: "", notificationID: "", reminderUnit: "Hours", reminderValue: 1)
    
    
    //var EditTask: Tasc
    
    
    //Due Date
    @State var dueDate: Date = Date()
    @State var letPickDate: Bool = false
    @State var letPickDateAndTime: Bool = false
    
    //Reminder
    @State var useReminder: Bool = false
    @State var reminderUnits: [String] = ["Days", "Hours", "Minutes"]
    
    //subtaks
    @State var addedSubtaskTitle: String = ""
    @State var useSubtasks: Bool = false
    @State var subtasks: [Subtasc] = []
    

    
    func addTasc() {
       
        newTasc.category = self.originalCategory
        newTasc.subtasks = self.subtasks
        
        
        
        
        if self.letPickDate && !self.letPickDateAndTime {
            //Date without Time gets insertet
            self.dueDate = self.dueDate.removeTimeStamp()
            newTasc.dueDate = self.dueDate
        }
        
        if self.letPickDate && self.letPickDateAndTime {
            //Date with Time gets insertet
            newTasc.dueDate = self.dueDate
        }
        
        if self.useReminder {
            let notificationDate = getSubtractedDate(unit: newTasc.reminderUnit!, value: newTasc.reminderValue!, inputDate: self.dueDate)
            //set Notification
            newTasc.notificationID = UUID().uuidString
            NotificationHandler.shared.scheduleNotificationWithDate(id: newTasc.notificationID!, title: "Task fällig in: \(newTasc.reminderValue!) \(newTasc.reminderUnit!)", subtitle: newTasc.title, date: notificationDate)
        }
        
        context.insert(newTasc)
        dismiss()
    }
    
    func formIsValid() -> Bool {
        guard !newTasc.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        if letPickDate {
            guard dueDate >= Calendar.current.date(byAdding: .minute, value: -5, to: Date())! else { return false }
        }
        
        if useReminder {
            guard !self.reminderDateisPastDate() else { return false }
        }
        return true
    }
    
    func moveSubtask(source: IndexSet, destination: Int){
        self.subtasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func reminderDateisPastDate() -> Bool {
        let notificationDate = getSubtractedDate(unit: newTasc.reminderUnit!, value: newTasc.reminderValue!, inputDate: self.dueDate)
        return notificationDate < Date()
    }
    
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Form {
                    
                    //Title
                    TextField("Titel", text: $newTasc.title)
                        .submitLabel(.next)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    if newTasc.title.trimmingCharacters(in: .whitespaces).isEmpty {
                        HStack {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 2.5)
                            Text("Titel darf nicht leer sein")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        
                    }
                    
                    Section {
                        TextField("Notizen", text: $newTasc.dscription,  axis: .vertical)
                            .lineLimit(5...10)
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(.green)
                                .cornerRadius(5)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 2.5)
                            
                            Text("Subtasks")
                            
                            //Datum toggle
                            Toggle("", isOn: $useSubtasks)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .onChange(of: useSubtasks) {
                                    self.subtasks = []
                            }
                            
                        }
                        if useSubtasks {
                            
                            EditButton()
                            HStack {
                                
                                TextField("hinzufügen", text: $addedSubtaskTitle)
                                    .submitLabel(.next)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Button{
                                    
                                    //Haptic Feedback on Tap
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                    impactHeavy.impactOccurred()
                                    subtasks.append(Subtasc(id: UUID(), title: addedSubtaskTitle, isDone: false))
                                    addedSubtaskTitle = ""
                                    
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 25))
                                    
                                }
                                .disabled(addedSubtaskTitle == "")
                                
                                
                            }
                            List {
                                ForEach($subtasks, id: \.self) { $sbtask in
                                    HStack {
                                        Text(sbtask.title)
                                        Spacer()
                                        Image(systemName: "circle")
                                            .foregroundColor(Color(hex: accentColor))
                                            .font(.system(size: 25))
                                    }
                                    
                                }
                                .onMove(perform: moveSubtask)
                                .onDelete { indexSet in
                                    subtasks.remove(atOffsets: indexSet)
                                    
                                }
                            }
                            
                        }
                            
                        
                    }
                    
                    Section {
                        //Categeory Selection
                        Picker("Kategorie", selection: $originalCategory) {
                            
                            ForEach(allCategories, id: \.self){
                                
                                Text($0.name)
                                
                            }
                        }
                        .pickerStyle(.menu)
                        
                    }
                    
                    
                    //Due Date Sections
                    Section {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(.red)
                                .cornerRadius(5)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 2.5)
                            
                            Text("Zu erledigen bis:")
                            
                            //Datum toggle
                            Toggle("", isOn: $letPickDate)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .onChange(of: letPickDate) { oldValue, newValue in
                                    //If no Date is selected, user reminders is deactivated
                                    if newValue == false {
                                        useReminder = false
                                        letPickDateAndTime = false
                                        self.dueDate = Date()
                                    }
                                }
                            
                        }
                        
                        if letPickDate && dueDate <= Calendar.current.date(byAdding: .minute, value: -5, to: Date())! {
                            HStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2.5)
                                Text("Datum darf nicht in der Vergangenheit liegen")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                            
                        }
                        
                        //Due Data
                        if letPickDate && !letPickDateAndTime {
                            DatePicker("only date", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        if letPickDate && letPickDateAndTime {
                            DatePicker("date and Time", selection: $dueDate)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        if letPickDate {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(.blue)
                                    .cornerRadius(5)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2.5)
                                
                                Text("Uhrzeit")
                                
                                //Datum toggle
                                Toggle("", isOn: $letPickDateAndTime)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                            }
                        }
                    }
                    
                    if letPickDate {
                        // Reminder Section
                        Section {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(.purple)
                                    .cornerRadius(5)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2.5)
                                
                                Text("Erinnern")
                                
                                //Datum toggle
                                Toggle("", isOn: $useReminder)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                            }
                            
                            if useReminder && reminderDateisPastDate() {
                                HStack {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .padding(.vertical, 2.5)
                                    Text("Reminder Zeit kann nicht in der Vergangenheit liegen.")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                                
                            }
                            
                            
                            
                            if useReminder {
                                Picker("\(newTasc.reminderUnit!) vorher:", selection: $newTasc.reminderUnit) {
                                    
                                    ForEach(reminderUnits, id: \.self){
                                        
                                        Text($0)
                                        
                                    }
                                }
                                .pickerStyle(.menu)
                                
                            }
                            
                            if newTasc.reminderUnit == "Hours" && useReminder {
                                Picker("", selection: $newTasc.reminderValue){
                                    ForEach(1..<13, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                            }
                            
                            if newTasc.reminderUnit == "Minutes" && useReminder {
                                Picker("", selection: $newTasc.reminderValue){
                                    ForEach(1..<60, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                            }
                            
                            if newTasc.reminderUnit == "Days" && useReminder {
                                Picker("", selection: $newTasc.reminderValue){
                                    ForEach(1..<7, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    Section {
                        //High Priority Toggle
                        Toggle("Hohe Priorität", isOn: $newTasc.isHighPriority)
                        //.padding(.vertical, 3)
                    }
                    
                    Section {
                        //Flagged Toggle
                        Toggle("Markiert", isOn: $newTasc.isFlagged)
                        //.padding(.vertical, 3)
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
                    Text("Neuer Task")
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        addTasc()
                        dismiss()
                        
                    } label: {
                        Text("hinzufügen")
                            .foregroundColor(Color(hex: accentColor))
                    }
                    .disabled(!formIsValid())
                    
                }
                
                
                
            }
        }
        
        
       
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}


#Preview {
    ModelPreview { category in
        addTaskView(originalCategory: category)
    }
}
