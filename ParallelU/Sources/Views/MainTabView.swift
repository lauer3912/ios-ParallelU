import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingCreator = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                .accessibilityIdentifier("tab_home")
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari.fill")
                }
                .tag(1)
                .accessibilityIdentifier("tab_explore")
            
            TimeCapsuleView()
                .tabItem {
                    Label("Capsules", systemImage: "clock.fill")
                }
                .tag(2)
                .accessibilityIdentifier("tab_capsules")
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
                .accessibilityIdentifier("tab_profile")
        }
        .tint(Color(hex: "9B8FE8"))
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "0F0F14"))
        
        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex: "9B8FE8"))
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "9B8FE8"))]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
