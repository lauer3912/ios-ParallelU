import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Your parallel self is waiting...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), quote: "Explore your parallel universe!")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries = [
            SimpleEntry(date: Date(), quote: "What choice would your parallel self make?"),
            SimpleEntry(date: Date().addingTimeInterval(3600), quote: "Another you made a different choice today."),
            SimpleEntry(date: Date().addingTimeInterval(7200), quote: "Time capsules unlock new possibilities.")
        ]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct ParallelUWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0F0F14"), Color(hex: "1a1a2e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "9B8FE8"), Color(hex: "6EE7B7")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(entry.quote)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
            }
            .padding()
        }
    }
}

struct ParallelUWidget: Widget {
    let kind: String = "ParallelUWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ParallelUWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("ParallelU")
        .description("Daily quotes from your parallel universe.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ParallelUWidget()
} timeline: {
    SimpleEntry(date: .now, quote: "Your parallel self is waiting...")
    SimpleEntry(date: .now, quote: "Explore different paths!")
}
