//
//  MoonPhaseWidget.swift
//  MoonPhaseWidget
//
//  Created by Dylan Park on 20/9/21.
//

import WidgetKit
import SwiftUI
import Intents

// Determines what data and when to provide it.
struct Provider: IntentTimelineProvider {
    
    // Placeholder, used before gathering data.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    // Provides a timeline entry representing the current time and state of a widget.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MoonPhaseWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct MoonPhaseWidget: Widget {
    let kind: String = "MoonPhaseWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MoonPhaseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Moon Phase Widget")
        .description("Get information about today's moon phase.")
    }
}

//MARK: - Previews

struct Small_MoonPhaseWidget_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct Medium_MoonPhaseWidget_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct Large_MoonPhaseWidget_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
