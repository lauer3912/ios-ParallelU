import SwiftUI

struct CapsulesView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCreateCapsule: Bool = false
    @State private var selectedFilter: CapsuleFilter = .all
    
    enum CapsuleFilter: String, CaseIterable {
        case all = "All"
        case locked = "Locked"
        case unlocked = "Unlocked"
    }
    
    var filteredCapsules: [TimeCapsule] {
        switch selectedFilter {
        case .all: return appState.capsules
        case .locked: return appState.capsules.filter { $0.isLocked }
        case .unlocked: return appState.capsules.filter { !$0.isLocked }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter
                filterBar
                
                // Capsules List
                if filteredCapsules.isEmpty {
                    emptyState
                } else {
                    capsulesList
                }
            }
            .navigationTitle("Time Capsules")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateCapsule = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "00d4ff"))
                    }
                }
            }
            .sheet(isPresented: $showCreateCapsule) {
                CreateCapsuleView()
            }
        }
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(CapsuleFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation { selectedFilter = filter }
                    } label: {
                        Text(filter.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedFilter == filter ? Color(hex: "00d4ff") : Color(hex: "16213e"))
                            )
                            .foregroundColor(selectedFilter == filter ? .black : .white)
                    }
                }
            }
            .padding()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No capsules yet")
                .font(.title2)
                .foregroundColor(.white)
            Text("Create a time capsule to send a message to your future self")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button("Create Capsule") {
                showCreateCapsule = true
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color(hex: "00d4ff"))
            .foregroundColor(.black)
            .cornerRadius(12)
            Spacer()
        }
        .padding()
    }
    
    private var capsulesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredCapsules) { capsule in
                    CapsuleListCard(capsule: capsule)
                }
            }
            .padding()
        }
    }
}

struct CapsuleListCard: View {
    let capsule: TimeCapsule
    @State private var showDetail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: capsule.privacy == .publicCapsule ? "globe" : capsule.privacy == .friendsOnly ? "person.2.fill" : "lock.fill")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(capsule.privacy.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if capsule.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.orange)
                } else {
                    Image(systemName: "lock.open.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(capsule.content)
                .font(.body)
                .foregroundColor(.white)
                .lineLimit(3)
            
            HStack {
                if capsule.isLocked {
                    Text("Unlocks in \(capsule.daysUntilUnlock) days")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("Unlocked!")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "16213e"))
        )
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            CapsuleDetailView(capsule: capsule)
        }
    }
}

struct CreateCapsuleView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var content: String = ""
    @State private var unlockDays: Int = 30
    @State private var privacy: CapsulePrivacy = .privateCapsule
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message to Future Self")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextEditor(text: $content)
                            .frame(minHeight: 150)
                            .padding()
                            .background(Color(hex: "16213e"))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    // Unlock Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Unlock Date")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Opens in \(unlockDays) days")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Slider(value: Binding(
                            get: { Double(unlockDays) },
                            set: { unlockDays = Int($0) }
                        ), in: 1...365, step: 1)
                        .tint(Color(hex: "00d4ff"))
                    }
                    
                    // Privacy
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(CapsulePrivacy.allCases, id: \.self) { priv in
                            Button {
                                privacy = priv
                            } label: {
                                HStack {
                                    Image(systemName: privacy == priv ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(privacy == priv ? Color(hex: "00d4ff") : .gray)
                                    Text(priv.rawValue)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(hex: "16213e"))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(hex: "1a1a2e"))
            .navigationTitle("Create Capsule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        appState.createCapsule(content: content, unlockDays: unlockDays, privacy: privacy)
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00d4ff"))
                    .disabled(content.isEmpty)
                }
            }
        }
    }
}

struct CapsuleDetailView: View {
    let capsule: TimeCapsule
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Status
                    HStack {
                        Image(systemName: capsule.isLocked ? "lock.fill" : "lock.open.fill")
                            .font(.title)
                            .foregroundColor(capsule.isLocked ? .orange : .green)
                        
                        VStack(alignment: .leading) {
                            Text(capsule.isLocked ? "Locked" : "Unlocked")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if capsule.isLocked {
                                Text("\(capsule.daysUntilUnlock) days until unlock")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "16213e"))
                    .cornerRadius(16)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(capsule.content)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "16213e"))
                    .cornerRadius(16)
                    
                    // Privacy
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: capsule.privacy == .publicCapsule ? "globe" : capsule.privacy == .friendsOnly ? "person.2.fill" : "lock.fill")
                            Text(capsule.privacy.rawValue)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "16213e"))
                    .cornerRadius(16)
                }
                .padding()
            }
            .background(Color(hex: "1a1a2e"))
            .navigationTitle("Capsule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "00d4ff"))
                }
            }
        }
    }
}

extension CapsulePrivacy: CaseIterable {
    public static var allCases: [CapsulePrivacy] = [.publicCapsule, .friendsOnly, .privateCapsule]
}

#Preview {
    CapsulesView()
        .environmentObject(AppState())
}