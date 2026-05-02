import SwiftUI

struct SocialView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: SocialSection = .discover
    
    enum SocialSection: String, CaseIterable {
        case discover = "Discover"
        case chat = "Chat"
        case debates = "Debates"
        case polls = "Polls"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Section picker
                sectionPicker
                
                // Content
                ScrollView {
                    switch selectedSection {
                    case .discover:
                        discoverContent
                    case .chat:
                        chatContent
                    case .debates:
                        debatesContent
                    case .polls:
                        pollsContent
                    }
                }
            }
            .navigationTitle("Social")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SocialSection.allCases, id: \.self) { section in
                    Button {
                        withAnimation { selectedSection = section }
                    } label: {
                        Text(section.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedSection == section ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedSection == section ? Color(hex: "00d4ff") : Color(hex: "16213e"))
                            )
                            .foregroundColor(selectedSection == section ? .black : .white)
                    }
                }
            }
            .padding()
        }
    }
    
    private var discoverContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Discover Parallels")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach(appState.parallelSelves) { selfie in
                DiscoverCard(selfie: selfie)
            }
            
            // Discovery Radar
            VStack(alignment: .leading, spacing: 8) {
                Text("Discovery Radar")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(LifePath.allCases.prefix(4), id: \.self) { path in
                        VStack {
                            Image(systemName: path.icon)
                                .font(.title2)
                                .foregroundColor(path.color)
                            Text("\(Int.random(in: 1...50))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color(hex: "16213e"))
                .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    private var chatContent: some View {
        VStack(spacing: 16) {
            if appState.parallelSelves.isEmpty {
                emptyChatState
            } else {
                ForEach(appState.parallelSelves) { selfie in
                    ChatListRow(selfie: selfie)
                }
            }
        }
        .padding()
    }
    
    private var emptyChatState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "message.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No conversations yet")
                .font(.title2)
                .foregroundColor(.white)
            Text("Start chatting with your parallel selves")
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private var debatesContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Universe Debates")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach(0..<3, id: \.self) { index in
                DebateCard(index: index)
            }
        }
        .padding(.vertical)
    }
    
    private var pollsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choice Polls")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach(0..<3, id: \.self) { index in
                PollCard(index: index)
            }
        }
        .padding(.vertical)
    }
}

struct DiscoverCard: View {
    let selfie: ParallelSelf
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(selfie.lifePath.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: selfie.lifePath.icon)
                    .font(.title2)
                    .foregroundColor(selfie.lifePath.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(selfie.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(selfie.lifePath.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    ForEach(selfie.powerWords.prefix(2), id: \.self) { word in
                        Text(word)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(hex: "00d4ff").opacity(0.2))
                            .foregroundColor(Color(hex: "00d4ff"))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
            
            Button("Connect") {
                // Connect action
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(hex: "00d4ff"))
            .foregroundColor(.black)
            .cornerRadius(12)
        }
        .padding()
        .background(Color(hex: "16213e"))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct ChatListRow: View {
    let selfie: ParallelSelf
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(selfie.lifePath.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: selfie.lifePath.icon)
                    .foregroundColor(selfie.lifePath.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(selfie.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Last message: Hello from \(selfie.name)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("2m ago")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(hex: "16213e"))
        .cornerRadius(12)
    }
}

struct DebateCard: View {
    let index: Int
    
    let debateQuestions = [
        "Which universe made the better career choice?",
        "Is following your passion worth the risk?",
        "Should you prioritize family over career?"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(debateQuestions[index])
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Button("Universe A") {
                    // Vote
                }
                .buttonStyle(UniverseVoteButtonStyle())
                
                Button("Universe B") {
                    // Vote
                }
                .buttonStyle(UniverseVoteButtonStyle())
            }
            
            HStack {
                Image(systemName: "person.fill")
                Text("\(Int.random(in: 10...100)) participating")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(hex: "16213e"))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct UniverseVoteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: "00d4ff").opacity(0.2))
            .foregroundColor(Color(hex: "00d4ff"))
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct PollCard: View {
    let index: Int
    
    let pollQuestions = [
        "What would your parallel self choose?",
        "Which life path seems more fulfilling?",
        "Should parallel selves share memories?"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(pollQuestions[index])
                .font(.subheadline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                VStack {
                    Text("\(Int.random(in: 30...70))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "00d4ff"))
                    Text("Option A")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(Int.random(in: 30...70))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    Text("Option B")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
            
            ProgressView(value: 0.5)
                .tint(Color(hex: "00d4ff"))
        }
        .padding()
        .background(Color(hex: "16213e"))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    SocialView()
        .environmentObject(AppState())
}