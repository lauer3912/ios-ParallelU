import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Parallel Selves Section
                    parallelSelvesSection
                    
                    // Recent Capsules Section
                    recentCapsulesSection
                    
                    // Trending Parallels Section
                    trendingSection
                }
                .padding()
            }
            .navigationTitle("ParallelU")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to Your Universes")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Explore your parallel selves and connect with others")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1a1a2e").opacity(0.8))
        )
    }
    
    private var parallelSelvesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Parallel Selves")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: AllParallelSelvesView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "00d4ff"))
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(appState.parallelSelves) { selfie in
                        ParallelSelfCard(selfie: selfie)
                    }
                }
            }
        }
    }
    
    private var recentCapsulesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Capsules")
                .font(.headline)
                .foregroundColor(.white)
            
            if appState.capsules.isEmpty {
                Text("No capsules yet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(appState.capsules.prefix(2)) { capsule in
                    CapsuleCard(capsule: capsule)
                }
            }
        }
    }
    
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trending Parallels")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(0..<3, id: \.self) { index in
                TrendingCard(index: index)
            }
        }
    }
}

struct ParallelSelfCard: View {
    let selfie: ParallelSelf
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(selfie.lifePath.color.opacity(0.3))
                    .frame(width: 80, height: 80)
                
                Image(systemName: selfie.lifePath.icon)
                    .font(.system(size: 32))
                    .foregroundColor(selfie.lifePath.color)
            }
            
            Text(selfie.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(selfie.lifePath.rawValue)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "16213e"))
        )
    }
}

struct CapsuleCard: View {
    let capsule: TimeCapsule
    
    var body: some View {
        HStack {
            Image(systemName: capsule.isLocked ? "lock.fill" : "lock.open.fill")
                .foregroundColor(capsule.isLocked ? .orange : .green)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(capsule.content)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text("\(capsule.daysUntilUnlock) days until unlock")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "1a1a2e"))
        )
    }
}

struct TrendingCard: View {
    let index: Int
    
    var body: some View {
        HStack {
            Text("\(index + 1)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "00d4ff"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Universe-\(["A", "B", "C"][index]) Explorer")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Active in Career path")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "16213e"))
        )
    }
}

struct AllParallelSelvesView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        List(appState.parallelSelves) { selfie in
            HStack {
                Image(systemName: selfie.lifePath.icon)
                    .foregroundColor(selfie.lifePath.color)
                    .font(.title2)
                    .frame(width: 40)
                
                VStack(alignment: .leading) {
                    Text(selfie.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(selfie.personality)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .listRowBackground(Color(hex: "16213e"))
        }
        .listStyle(.plain)
        .background(Color(hex: "1a1a2e"))
        .navigationTitle("All Parallel Selves")
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}