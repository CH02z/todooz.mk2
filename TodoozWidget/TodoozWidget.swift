//
//  TodoozWidget.swift
//  TodoozWidget
//
//  Created by Chris Zimmermann on 27.09.23.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    
    @MainActor
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(date: .now, TodayTasks: [])
    }
    
    @MainActor
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(date: .now, TodayTasks: [])
        completion(entry)
    }
    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        //Fetch SwiftData Data here:
        
       
        
        let todayTascs = self.getTodayTasks()
        let entries: [TaskEntry] = [TaskEntry(date: .now, TodayTasks: todayTascs)]
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    @MainActor
    private func getTodayTasks() -> [Tasc] {
        guard let modelContainer = try? ModelContainer(for: Tasc.self) else {
            return []
        }
        let predicate = #Predicate<Tasc> { $0.isDone == false }
        let descriptor = FetchDescriptor(predicate: predicate)
        let allTascs = try? modelContainer.mainContext.fetch(descriptor)
        
        //Filter For Tascs that are Due for Today
        var todayTascs: [Tasc] {
            let todayTascs = allTascs!.compactMap { tasc in
                    if tasc.dueDate != nil {
                        return (tasc.dueDate!.isToday) ? tasc : nil
                    } else {
                        return nil
                    }
            }
            return todayTascs
            
        }
        
        return todayTascs ?? []
        
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date
    let TodayTasks: [Tasc]
}

struct TodoozWidgetEntryView : View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"

    
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, content: {
            
            HStack {
                Text("Heute")
                //.font(.caption)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                    .foregroundColor(Color(hex: accentColor))
                
                Spacer()
                
                Text("\(entry.TodayTasks.count)")
                    .fontWeight(.semibold)
                
                
            }
            
            
            VStack(alignment: .leading, spacing: 6, content: {
                if entry.TodayTasks.isEmpty {
                    Text("Keine Tasks")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(0..<entry.TodayTasks.count) {
                        if $0 <= 2 {
                            WidgetTaskRowView(tasc: entry.TodayTasks[$0], rowIndex: Int($0))
                        }
                        
                    }
                }
            })
            
        })
    }
}

struct TodoozWidget: Widget {
    let kind: String = "TodoozWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TodoozWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodoozWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Task Widget")
        .description("This is an example widget.")
    }
}





struct WidgetTaskRowView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @Bindable var tasc: Tasc
    let rowIndex: Int
    
    @State var isStrikeThrough: Bool = false

    var body: some View {
        HStack {
            
            if tasc.isHighPriority {
                Image(systemName: "exclamationmark")
                    .foregroundColor(Color.red)
                    .font(.system(size: 15))
                    .padding(.horizontal, 5)
            }
            
            if tasc.isFlagged {
                Image(systemName: "flag")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 15))
                    .padding(.horizontal, 5)
            }
            
            if tasc.dueDate != nil && tasc.dueDate!.isPast {
                Image(systemName: "clock.badge.exclamationmark")
                    .foregroundColor(Color.red)
                    .font(.system(size: 15))
                    .padding(.horizontal, 5)
            }
            
            VStack(alignment: .leading, content: {
                Text(tasc.title)
                    .textScale(.secondary)
                    .lineLimit(1)
                    .strikethrough(isStrikeThrough)
                if rowIndex != 2 {
                    Divider()
                }
                
            })
            
                
                

            
            Spacer()
            
            Button(intent: ToggleStateIntent(id: tasc.title)) {
                Image(systemName: tasc.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color(hex: accentColor))
            }
            .buttonStyle(.plain)
            
            
            
        }
        
    }
}






extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Date {
    
    // Checking Whether the Date is Today
    var isToday: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.isDateInToday(self)
    }
    // Checking if the date is Past Hours
    var isPast: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "CEST")!
        return calendar.compare(self, to: .init(), toGranularity: .minute) == .orderedAscending
    }
    // Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CEST")!
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

struct ToggleStateIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task State"
    
    /// Parameters
    @Parameter(title: "Task ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    @MainActor
    private func getTascByID(id: String) -> Tasc {
        guard let modelContainer = try? ModelContainer(for: Tasc.self) else {
            return Tasc(title: "")
        }
        let predicate = #Predicate<Tasc> { $0.title == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        let tascs = try? modelContainer.mainContext.fetch(descriptor)
        return tascs![0] ?? Tasc(title: "")
    }
    
    func perform() async throws -> some IntentResult {
        
        print("task intent triggered")
        // UPDATE YOUR DATABASE HERE
        
        var tasc = await getTascByID(id: self.id)
        tasc.isDone.toggle()
        
        
        
       
        return .result()
    }
}





#Preview(as: .systemSmall) {
    TodoozWidget()
} timeline: {
    TaskEntry(date: .now, TodayTasks: [])
    TaskEntry(date: .now, TodayTasks: [])
}
