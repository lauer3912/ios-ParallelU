import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Background gradient based on dark mode
            LinearGradient(
                colors: appState.isDarkMode
                    ? [Color(hex: "1a1a2e"), Color(hex: "16213e")]
                    : [Color.white, Color(hex: "f0f0f5")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $appState.selectedTab) {
                HomeView()
                    .tabItem {
                        Label(AppState.Tab.home.title, systemImage: AppState.Tab.home.icon)
                    }
                    .tag(AppState.Tab.home)
                
                CreateParallelSelfView()
                    .tabItem {
                        Label(AppState.Tab.create.title, systemImage: AppState.Tab.create.icon)
                    }
                    .tag(AppState.Tab.create)
                
                CapsulesView()
                    .tabItem {
                        Label(AppState.Tab.capsules.title, systemImage: AppState.Tab.capsules.icon)
                    }
                    .tag(AppState.Tab.capsules)
                
                SocialView()
                    .tabItem {
                        Label(AppState.Tab.social.title, systemImage: AppState.Tab.social.icon)
                    }
                    .tag(AppState.Tab.social)
                
                SettingsView()
                    .tabItem {
                        Label(AppState.Tab.settings.title, systemImage: AppState.Tab.settings.icon)
                    }
                    .tag(AppState.Tab.settings)
            }
            .tint(Color(hex: "00d4ff"))
        }
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

#Preview {
    ContentView()
        .environmentObject(AppState())
}