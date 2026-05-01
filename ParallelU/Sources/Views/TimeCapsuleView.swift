import SwiftUI

struct TimeCapsuleView: View {
    @StateObject private var viewModel = TimeCapsuleViewModel()
    @State private var showingCreator = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Stats Header
                        statsHeader
                        
                        // Create New Capsule Button
                        Button(action: { showingCreator = true }) {
                            Label("Create New Capsule", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                        }
                        
                        // Unlocked Capsules
                        if !viewModel.unlockedCapsules.isEmpty {
                            capsuleSection(title: "Ready to Open", capsules: viewModel.unlockedCapsules, accentColor: "6EE7B7")
                        }
                        
                        // Upcoming Capsules
                        if !viewModel.upcomingCapsules.isEmpty {
                            capsuleSection(title: "Coming Soon", capsules: viewModel.upcomingCapsules, accentColor: "9B8FE8")
                        }
                        
                        // Locked Capsules
                        if !viewModel.lockedCapsules.isEmpty {
                            capsuleSection(title: "Sealed Away", capsules: viewModel.lockedCapsules, accentColor: "6B7280")
                        }
                        
                        if viewModel.allCapsules.isEmpty {
                            emptyState
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Time Capsules")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingCreator) {
                CapsuleCreatorView { capsule in
                    viewModel.addCapsule(capsule)
                }
            }
        }
        .onAppear {
            viewModel.loadCapsules()
        }
    }
    
    // MARK: - Stats Header
    
    private var statsHeader: some View {
        HStack(spacing: 16) {
            StatCard(value: "\(viewModel.unlockedCapsules.count)", label: "Ready", color: "6EE7B7", icon: "lock.open.fill")
            StatCard(value: "\(viewModel.upcomingCapsules.count)", label: "Upcoming", color: "9B8FE8", icon: "clock.fill")
            StatCard(value: "\(viewModel.lockedCapsules.count)", label: "Sealed", color: "6B7280", icon: "lock.fill")
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No Time Capsules Yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Send messages to your parallel selves or future self")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - Capsule Section
    
    private func capsuleSection(title: String, capsules: [TimeCapsule], accentColor: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(capsules) { capsule in
                CapsuleCard(capsule: capsule, accentColor: accentColor) {
                    viewModel.openCapsule(capsule)
                }
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let value: String
    let label: String
    let color: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.title2)
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

// MARK: - Capsule Card

struct CapsuleCard: View {
    let capsule: TimeCapsule
    let accentColor: String
    let onOpen: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: capsule.isUnlocked && !capsule.isOpened ? "lock.open.fill" : "lock.fill")
                    .foregroundColor(Color(hex: accentColor))
                
                Text(capsule.title.isEmpty ? "Time Capsule" : capsule.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if capsule.isOpened {
                    Text("Opened")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6EE7B7"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "6EE7B7").opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Text(capsule.message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Label(capsule.unlockDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Label(capsule.privacy.rawValue, systemImage: capsule.privacy.icon)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if capsule.isUnlocked && !capsule.isOpened {
                Button(action: onOpen) {
                    Text("Open Capsule")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: accentColor))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - ViewModel

@MainActor
final class TimeCapsuleViewModel: ObservableObject {
    @Published var allCapsules: [TimeCapsule] = []
    
    var unlockedCapsules: [TimeCapsule] {
        allCapsules.filter { $0.isUnlocked }
    }
    
    var upcomingCapsules: [TimeCapsule] {
        let now = Date()
        let weekLater = now.addingTimeInterval(86400 * 7)
        return allCapsules.filter { !$0.isUnlocked && $0.unlockDate <= weekLater }
    }
    
    var lockedCapsules: [TimeCapsule] {
        let weekLater = Date().addingTimeInterval(86400 * 7)
        return allCapsules.filter { !$0.isUnlocked && $0.unlockDate > weekLater }
    }
    
    func loadCapsules() {
        allCapsules = DataManager.shared.loadUserProfile().capsules.sorted { $0.unlockDate < $1.unlockDate }
    }
    
    func addCapsule(_ capsule: TimeCapsule) {
        DataManager.shared.addCapsule(capsule)
        loadCapsules()
    }
    
    func openCapsule(_ capsule: TimeCapsule) {
        DataManager.shared.openCapsule(id: capsule.id)
        loadCapsules()
    }
}

// MARK: - Capsule Creator View

struct CapsuleCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var message = ""
    @State private var unlockDays = 30
    @State private var privacy: CapsulePrivacy = .privateCapsule
    
    let onCreate: (TimeCapsule) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Capsule Title", systemImage: "pencil")
                                .font(.headline)
                                .foregroundColor(Color(hex: "FCD34D"))
                            TextField("Name your capsule", text: $title)
                                .textFieldStyle(ParallelUTextFieldStyle())
                        }
                        
                        // Message
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Message to Future Self", systemImage: "text.bubble")
                                .font(.headline)
                                .foregroundColor(Color(hex: "FCD34D"))
                            TextEditor(text: $message)
                                .frame(minHeight: 120)
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        // Unlock Time
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Unlock In", systemImage: "clock")
                                .font(.headline)
                                .foregroundColor(Color(hex: "FCD34D"))
                            
                            Picker("Days", selection: $unlockDays) {
                                Text("1 Day").tag(1)
                                Text("7 Days").tag(7)
                                Text("30 Days").tag(30)
                                Text("90 Days").tag(90)
                                Text("1 Year").tag(365)
                            }
                            .pickerStyle(.segmented)
                            .tint(Color(hex: "FCD34D"))
                        }
                        
                        // Privacy
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Privacy", systemImage: "lock")
                                .font(.headline)
                                .foregroundColor(Color(hex: "FCD34D"))
                            
                            ForEach(CapsulePrivacy.allCases, id: \.self) { level in
                                Button(action: { privacy = level }) {
                                    HStack {
                                        Image(systemName: privacy == level ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(privacy == level ? Color(hex: "FCD34D") : .gray)
                                        Image(systemName: level.icon)
                                        Text(level.rawValue)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("New Time Capsule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "9B8FE8"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Seal") {
                        let capsule = TimeCapsule(
                            title: title,
                            message: message,
                            createdAt: Date(),
                            unlockDate: Date().addingTimeInterval(Double(unlockDays) * 86400),
                            privacy: privacy
                        )
                        onCreate(capsule)
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "FCD34D"))
                    .disabled(message.isEmpty)
                }
            }
        }
    }
}

#Preview {
    TimeCapsuleView()
}