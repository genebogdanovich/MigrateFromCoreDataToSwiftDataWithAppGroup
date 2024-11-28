//
//  MigrateFromCoreDataToSwiftDataWithAppGroupWidgets.swift
//  MigrateFromCoreDataToSwiftDataWithAppGroupWidgets
//
//  Created by Gene Bogdanovich on 26.11.24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    
    private let modelContainer: ModelContainer
    
    init() {
        let applicationSupportDirectoryURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.genebogdanovich.MigrateFromCoreDataToSwiftDataWithAppGroup")!
        let url = applicationSupportDirectoryURL.appending(path: "MigrateFromCoreDataToSwiftDataWithAppGroup.sqlite")
        
        modelContainer = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(url: url))
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", count: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", count: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task { @MainActor in
            let fetchDescriptor = FetchDescriptor<Item>()
            
            let items: [Item] = try! modelContainer.mainContext.fetch(fetchDescriptor)
            
            let entry = SimpleEntry(date: .now, emoji: "😀", count: items.count)
            
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let count: Int
}

struct MigrateFromCoreDataToSwiftDataWithAppGroupWidgetsEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            
            Text("Emoji:")
            Text(entry.emoji)
            
            Text("Count:")
            Text(entry.count.formatted())
        }
    }
}

struct MigrateFromCoreDataToSwiftDataWithAppGroupWidgets: Widget {
    let kind: String = "MigrateFromCoreDataToSwiftDataWithAppGroupWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MigrateFromCoreDataToSwiftDataWithAppGroupWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MigrateFromCoreDataToSwiftDataWithAppGroupWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    MigrateFromCoreDataToSwiftDataWithAppGroupWidgets()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", count: 0)
    SimpleEntry(date: .now, emoji: "🤩", count: 0)
}
