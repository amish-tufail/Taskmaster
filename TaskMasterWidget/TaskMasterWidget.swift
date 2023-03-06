//
//  TaskMasterWidget.swift
//  TaskMasterWidget
//
//  Created by Amish Tufail on 06/03/2023.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TaskMasterWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default) private var items: FetchedResults<Item>
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                backgroundGradient
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                Image("logo")
                    .resizable()
                    .frame(width: 36.0, height: 36.0)
                    .offset(x: (proxy.size.width / 2) - 20, y: (proxy.size.width / -2) + 20)
                    .padding(.top, 12.0)
                    .padding(.trailing, 12.0)
                
            }
        }
    }
}

struct TaskMasterWidget: Widget {
    let kind: String = "TaskMasterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskMasterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Task Master Launcher")
        .description("This is an example widget for the personal Task .")
    }
}

struct TaskMasterWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskMasterWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            TaskMasterWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            TaskMasterWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
