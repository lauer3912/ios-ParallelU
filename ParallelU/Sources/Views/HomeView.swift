import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Parallel Selves Cards
                        if viewModel.parallelSelves.isEmpty {
                            emptyStateView
                        } else {
                            parallelSelvesSection
                        }
                        
                        // Quick Actions
                        quickActionsSection
                        
                        // Upcoming Capsules
                        if !viewModel.upcomingCapsules.isEmpty {
                            upcomingCapsulesSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("ParallelU")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back, Explorer")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Which universe will you explore today?")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "9B8FE8"), Color(hex: "6EE7B7")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No Parallel Selves Yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Create your first parallel self to start exploring different universes")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - Parallel Selves Section
    
    private var parallelSelvesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Parallel Selves")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(viewModel.parallelSelves) { parallelSelf in
                ParallelSelfCard(parallelSelf: parallelSelf)
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Create New",
                    icon: "plus.circle.fill",
                    gradient: [Color(hex: "9B8FE8"), Color(hex: "6366F1")],
                    action: {}
                )
                
                QuickActionButton(
                    title: "Time Capsule",
                    icon: "clock.fill",
                    gradient: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
                    action: {}
                )
                
                QuickActionButton(
                    title: "Explore",
                    icon: "safari.fill",
                    gradient: [Color(hex: "6EE7B7"), Color(hex: "10B981")],
                    action: {}
                )
            }
        }
    }
    
    // MARK: - Upcoming Capsules
    
    private var upcomingCapsulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Capsules")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(viewModel.upcomingCapsules) { capsule in
                CapsulePreviewCard(capsule: capsule)
            }
        }
    }
}

// MARK: - Parallel Self Card

struct ParallelSelfCard: View {
    let parallelSelf: ParallelSelf
    
    var body: some View {
        ZStack {
            // Background gradient based on theme
            LinearGradient(
                colors: parallelSelf.universeTheme.gradientColors.map { Color(hex: $0) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: parallelSelf.universeTheme.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(parallelSelf.universeName)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Text(parallelSelf.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    ForEach(parallelSelf.lifePaths) { path in
                        Label(path.rawValue, systemImage: path.icon)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                
                HStack {
                    ForEach(parallelSelf.personalityTraits.prefix(3)) { trait in
                        Text(trait.emoji)
                            .font(.caption)
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .cornerRadius(16)
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let title: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Capsule Preview Card

struct CapsulePreviewCard: View {
    let capsule: TimeCapsule
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(capsule.title.isEmpty ? "Time Capsule" : capsule.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("Unlocks in \(capsule.unlockDate.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - ViewModel

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var parallelSelves: [ParallelSelf] = []
    @Published var upcomingCapsules: [TimeCapsule] = []
    
    func loadData() {
        let profile = DataManager.shared.loadUserProfile()
        parallelSelves = profile.parallelSelves
        upcomingCapsules = DataManager.shared.getUpcomingCapsules()
    }
}

#Preview {
    HomeView()
}