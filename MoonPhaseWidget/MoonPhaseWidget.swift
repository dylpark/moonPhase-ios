//
//  MoonPhaseWidget.swift
//  MoonPhaseWidget
//
//  Created by Dylan Park on 20/9/21.
//

import WidgetKit
import SwiftUI
import Intents
import CoreLocation

// Determines what data and when to provide it.
struct Provider: IntentTimelineProvider {
    
    var moonManager = MoonManager()
    var phaseAgeCalc = PhaseAgeCalc()
    var date = Date()
    let dateFormatter = DateFormatter()
    let savedLocation = UserDefaults.standard.location()
    
    struct SimpleEntry: TimelineEntry {
        let date: Date
        let configuration: ConfigurationIntent
        let phaseName: String
        let sunriseTime: String
        let sunsetTime: String
        let moonriseTime: String
        let moonsetTime: String
        let moonIllumination: String
        var moonPhaseImage: UIImage
    }
    
    func fetchMoonForLocation(location: CLLocation, moonManager: MoonManager, moon: MoonModel) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let location = savedLocation {
            moonManager.fetchMoon(latitude: location.latitude,
                                  longitude: location.longitude,
                                  date: dateFormatter.string(from: date))
        } else if savedLocation == nil {
            let brisbane = CLLocation(latitude: -27.470125, longitude: 153.021072)
            moonManager.fetchMoon(latitude: brisbane.coordinate.latitude,
                                  longitude: brisbane.coordinate.longitude,
                                  date: dateFormatter.string(from: date))
        }
        
//        let sunriseTime = moon.sunriseTime
//        let sunsetTime = moon.sunsetTime
//        let moonriseTime = moon.moonriseTime
//        let moonsetTime = moon.moonsetTime
//        let phaseName = moon.moonPhaseNames.rawValue
//        let moonIlluminationLabel = "\(moon.moonIllumination)%"
//        let phaseImageView = moon.moonPhaseImage
    }
    
    // Placeholder, used before gathering data.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: date,
                    configuration: ConfigurationIntent(),
                    phaseName: "New Moon",
                    sunriseTime: "00:00am",
                    sunsetTime: "00:00am",
                    moonriseTime: "00:00am",
                    moonsetTime: "00:00am",
                    moonIllumination: "00%",
                    moonPhaseImage: UIImage(imageLiteralResourceName: "New Moon")
        )
    }
    
    // Provides a timeline entry representing the current time and state of a widget.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
    }

    // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            _ = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: <#T##Date#>, configuration: <#T##ConfigurationIntent#>, phaseName: <#T##String#>, sunriseTime: <#T##String#>, sunsetTime: <#T##String#>, moonriseTime: <#T##String#>, moonsetTime: <#T##String#>, moonIllumination: <#T##String#>, moonPhaseImage: <#T##UIImage#>)
//            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
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

//struct Small_MoonPhaseWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MoonPhaseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
//
//struct Medium_MoonPhaseWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MoonPhaseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
//
//struct Large_MoonPhaseWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MoonPhaseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
//    }
//}
