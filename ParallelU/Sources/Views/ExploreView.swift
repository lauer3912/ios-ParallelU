import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search universes...", text: $viewModel.searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        
                        // Universe Map Section
                        universeMapSection
                        
                        // Trending Parallels
                        trendingSection
                        
                        // Near Universes
                        nearUniversesSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Universe Map
    
    private var universeMapSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Universe Map")
                .font(.headline)
                .foregroundColor(.white)
            
            ZStack {
                // Background stars
                ForEach(0..<30, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.1...0.5)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...350),
                            y: CGFloat.random(in: 0...200)
                        )
                }
                
                // Universe nodes
                ForEach(Array(viewModel.nearbyUniverses.enumerated()), id: \.element.id) { index, universe in
                    UniverseNode(universe: universe)
                        .position(
                            x: 60 + CGFloat(index % 4) * 90,
                            y: 50 + CGFloat(index / 4) * 80
                        )
                }
            }
            .frame(height: 200)
            .background(Color.white.opacity(0.03))
            .cornerRadius(16)
        }
    }
    
    // MARK: - Trending Section
    
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending Parallels")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("See All")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9B8FE8"))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        TrendingCard(index: index)
                    }
                }
            }
        }
    }
    
    // MARK: - Near Universes
    
    private var nearUniversesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Near Your Universe")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(viewModel.nearbyUniverses) { universe in
                NearUniverseRow(universe: universe)
            }
        }
    }
}

// MARK: - Universe Node

struct UniverseNode: View {
    let universe: ParallelSelf
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: universe.universeTheme.gradientColors.map { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: universe.universeTheme.icon)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            Text(universe.universeName)
                .font(.system(size: 8))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
}

// MARK: - Trending Card

struct TrendingCard: View {
    let index: Int
    
    private let gradients: [[String]] = [
        ["9B8FE8", "6366F1"],
        ["6EE7B7", "10B981"],
        ["F472B6", "EC4899"],
        ["FCD34D", "F59E0B"],
        ["FB923C", "EA580C"]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradients[index % gradients.count].map { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text("\(index + 1)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text("Parallel #\(index + 1)")
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(width: 80)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Near Universe Row

struct NearUniverseRow: View {
    let universe: ParallelSelf
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: universe.universeTheme.gradientColors.map { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: universe.universeTheme.icon)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(universe.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(universe.universeName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(universe.lifePaths.prefix(2)) { path in
                    Image(systemName: path.icon)
                        .font(.caption2)
                        .foregroundColor(Color(hex: path.color))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - ViewModel

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var nearbyUniverses: [ParallelSelf] = []
    
    func loadData() {
        let profile = DataManager.shared.loadUserProfile()
        nearbyUniverses = profile.parallelSelves
        
        // Add sample data for demo
        if nearbyUniverses.isEmpty {
            nearbyUniverses = [
                ParallelSelf(name: "Career Me", universeName: "Universe B", lifePaths: [.career]),
                ParallelSelf(name: "Family Me", universeName: "Universe C", lifePaths: [.family]),
                ParallelSelf(name: "Adventure Me", universeName: "Universe D", lifePaths: [.adventure])
            ]
        }
    }
}

#Preview {
    ExploreView()
}