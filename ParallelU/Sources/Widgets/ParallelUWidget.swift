import WidgetKit
import SwiftUI

struct ParallelUWidgetEntry: TimelineEntry {
    let date: Date
    let quote: String
    let capsuleCountdown: Int?
}

struct ParallelUWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> ParallelUWidgetEntry {
        ParallelUWidgetEntry(date: Date(), quote: "Your parallel self is waiting...", capsuleCountdown: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ParallelUWidgetEntry) -> Void) {
        let entry = ParallelUWidgetEntry(date: Date(), quote: "Explore your universes!", capsuleCountdown: 5)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ParallelUWidgetEntry>) -> Void) {
        let quotes = [
            "In another universe, you're already successful",
            "Your parallel self believes in you",
            "Every choice creates a new universe",
            "Time is relative in the multiverse"
        ]
        
        let currentDate = Date()
        let entry = ParallelUWidgetEntry(
            date: currentDate,
            quote: quotes.randomElement() ?? "Explore your universes!",
            capsuleCountdown: Int.random(in: 1...30)
        )
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct ParallelUWidgetEntryView: View {
    var entry: ParallelUWidgetProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        default:
            smallWidget
        }
    }
    
    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(hex: "00d4ff"))
                Text("ParallelU")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(entry.quote)
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(3)
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var mediumWidget: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(hex: "00d4ff"))
                    Text("ParallelU")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(entry.quote)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            
            if let countdown = entry.capsuleCountdown {
                Divider()
                    .background(Color.gray)
                
                VStack {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "00d4ff"))
                    
                    Text("\(countdown)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("days")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

@main
struct ParallelUWidget: Widget {
    let kind: String = "ParallelUWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ParallelUWidgetProvider()) { entry in
            ParallelUWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Parallel")
        .description("See a thought from your parallel self and capsule countdown.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}