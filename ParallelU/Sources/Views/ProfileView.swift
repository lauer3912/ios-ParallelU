import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        profileHeader
                        
                        // Stats
                        statsSection
                        
                        // Settings
                        settingsSection
                        
                        // Parallel Selves List
                        parallelSelvesSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color(hex: "9B8FE8"))
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "9B8FE8"), Color(hex: "6EE7B7")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text(viewModel.displayName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Explorer since \(viewModel.memberSince)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical)
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            ProfileStatCard(value: "\(viewModel.parallelSelfCount)", label: "Parallels", icon: "person.2.fill", color: "9B8FE8")
            ProfileStatCard(value: "\(viewModel.capsuleCount)", label: "Capsules", icon: "clock.fill", color: "FCD34D")
            ProfileStatCard(value: "\(viewModel.universePoints)", label: "Points", icon: "star.fill", color: "6EE7B7")
        }
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "bell.fill", title: "Notifications", color: "EF4444")
            SettingsRow(icon: "lock.fill", title: "Privacy", color: "6366F1")
            SettingsRow(icon: "icloud.fill", title: "Sync", color: "0EA5E9")
            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: "6EE7B7")
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    // MARK: - Parallel Selves Section
    
    private var parallelSelvesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Parallel Selves")
                .font(.headline)
                .foregroundColor(.white)
            
            if viewModel.parallelSelves.isEmpty {
                Text("No parallel selves created yet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(viewModel.parallelSelves) { self_ in
                    ParallelSelfRow(parallelSelf: self_) {
                        viewModel.deleteParallelSelf(self_)
                    }
                }
            }
        }
    }
}

// MARK: - Profile Stat Card

struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color(hex: color))
                    .frame(width: 30)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

// MARK: - Parallel Self Row

struct ParallelSelfRow: View {
    let parallelSelf: ParallelSelf
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: parallelSelf.universeTheme.gradientColors.map { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: parallelSelf.universeTheme.icon)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(parallelSelf.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(parallelSelf.universeName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // App Theme
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Appearance")
                                .font(.headline)
                                .foregroundColor(Color(hex: "9B8FE8"))
                            
                            ForEach(["Cosmic Dark", "Light Mode"], id: \.self) { theme in
                                HStack {
                                    Text(theme)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if theme == "Cosmic Dark" {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color(hex: "9B8FE8"))
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(10)
                            }
                        }
                        
                        // About
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(.headline)
                                .foregroundColor(Color(hex: "9B8FE8"))
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Version")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.white)
                                }
                                
                                HStack {
                                    Text("Build")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("1")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hex: "9B8FE8"))
                }
            }
        }
    }
}

// MARK: - ViewModel

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName = "Explorer"
    @Published var parallelSelves: [ParallelSelf] = []
    @Published var memberSince = ""
    
    var parallelSelfCount: Int { parallelSelves.count }
    var capsuleCount: Int { DataManager.shared.loadUserProfile().capsules.count }
    var universePoints: Int { parallelSelfCount * 100 + capsuleCount * 10 }
    
    func loadData() {
        let profile = DataManager.shared.loadUserProfile()
        displayName = profile.displayName
        parallelSelves = profile.parallelSelves
        memberSince = profile.createdAt.formatted(.dateTime.month().year())
    }
    
    func deleteParallelSelf(_ self_: ParallelSelf) {
        DataManager.shared.deleteParallelSelf(id: self_.id)
        loadData()
    }
}

#Preview {
    ProfileView()
}