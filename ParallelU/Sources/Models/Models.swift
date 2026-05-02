import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var parallelSelves: [ParallelSelf] = []
    @Published var capsules: [TimeCapsule] = []
    @Published var selectedTab: Tab = .home
    @Published var isDarkMode: Bool = true
    @Published var notificationsEnabled: Bool = true
    
    enum Tab: Int, CaseIterable {
        case home = 0
        case create = 1
        case capsules = 2
        case social = 3
        case settings = 4
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .create: return "Create"
            case .capsules: return "Capsules"
            case .social: return "Social"
            case .settings: return "Settings"
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .create: return "plus.circle.fill"
            case .capsules: return "clock.fill"
            case .social: return "person.2.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    init() {
        // Initialize with sample data for demonstration
        currentUser = User(id: UUID(), name: "You", avatarColor: .blue)
        loadSampleData()
    }
    
    func loadSampleData() {
        // Sample parallel selves
        parallelSelves = [
            ParallelSelf(id: UUID(), name: "Universe-A", lifePath: .career, personality: "Ambitious", background: "Cosmic Purple", powerWords: ["Determined", "Focused", "Success"], emotionPalette: [.calm, .energetic], talents: ["Leadership", "Strategy"]),
            ParallelSelf(id: UUID(), name: "Universe-B", lifePath: .family, personality: "Nurturing", background: "Deep Blue", powerWords: ["Loving", "Caring", "Present"], emotionPalette: [.peaceful, .joyful], talents: ["Empathy", "Teaching"]),
            ParallelSelf(id: UUID(), name: "Universe-C", lifePath: .adventure, personality: "Free Spirit", background: "Nebula Pink", powerWords: ["Free", "Explore", "Live"], emotionPalette: [.excited, .curious], talents: ["Creativity", "Adventure"])
        ]
        
        // Sample capsules
        capsules = [
            TimeCapsule(id: UUID(), authorId: UUID(), content: "A message to my past self...", unlockDate: Date().addingTimeInterval(86400 * 30), privacy: .friendsOnly, isLocked: true),
            TimeCapsule(id: UUID(), authorId: UUID(), content: "What would I tell myself in 5 years?", unlockDate: Date().addingTimeInterval(86400 * 7), privacy: .publicCapsule, isLocked: false)
        ]
    }
    
    func createParallelSelf(name: String, lifePath: LifePath, personality: String, background: String, powerWords: [String], emotionPalette: [Emotion], talents: [String]) {
        let newSelf = ParallelSelf(id: UUID(), name: name, lifePath: lifePath, personality: personality, background: background, powerWords: powerWords, emotionPalette: emotionPalette, talents: talents)
        parallelSelves.append(newSelf)
    }
    
    func createCapsule(content: String, unlockDays: Int, privacy: CapsulePrivacy) {
        let capsule = TimeCapsule(id: UUID(), authorId: currentUser?.id ?? UUID(), content: content, unlockDate: Date().addingTimeInterval(86400 * Double(unlockDays)), privacy: privacy, isLocked: true)
        capsules.append(capsule)
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var avatarColor: String
}

struct ParallelSelf: Identifiable, Codable {
    let id: UUID
    var name: String
    var lifePath: LifePath
    var personality: String
    var background: String
    var powerWords: [String]
    var emotionPalette: [Emotion]
    var talents: [String]
    var timeline: [TimelineEvent] = []
    var alternateHistory: String = ""
    var memoryFragments: String = ""
    var cloneOriginal: Bool = false
    var universeNaming: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name, lifePath, personality, background, powerWords, emotionPalette, talents, timeline, alternateHistory, memoryFragments, cloneOriginal, universeNaming
    }
}

enum LifePath: String, Codable, CaseIterable {
    case career = "Career"
    case family = "Family"
    case creativity = "Creativity"
    case adventure = "Adventure"
    case finance = "Finance"
    case health = "Health"
    
    var icon: String {
        switch self {
        case .career: return "briefcase.fill"
        case .family: return "heart.fill"
        case .creativity: return "paintbrush.fill"
        case .adventure: return "airplane"
        case .finance: return "dollarsign.circle.fill"
        case .health: return "cross.case.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .career: return .blue
        case .family: return .pink
        case .creativity: return .purple
        case .adventure: return .orange
        case .finance: return .green
        case .health: return .red
        }
    }
}

enum Emotion: String, Codable, CaseIterable {
    case calm, energetic, peaceful, joyful, excited, curious, reflective, passionate
    
    var color: Color {
        switch self {
        case .calm: return .blue
        case .energetic: return .yellow
        case .peaceful: return .green
        case .joyful: return .pink
        case .excited: return .orange
        case .curious: return .purple
        case .reflective: return .indigo
        case .passionate: return .red
        }
    }
}

struct TimelineEvent: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var description: String
}

enum CapsulePrivacy: String, Codable {
    case publicCapsule = "Public"
    case friendsOnly = "Friends Only"
    case privateCapsule = "Private"
}

struct TimeCapsule: Identifiable, Codable {
    let id: UUID
    let authorId: UUID
    var content: String
    var unlockDate: Date
    var privacy: CapsulePrivacy
    var isLocked: Bool
    var responses: [CapsuleResponse] = []
    var imageArtifacts: [String] = []
    var reminderSet: Bool = false
    
    var isUnlockable: Bool {
        Date() >= unlockDate && isLocked
    }
    
    var daysUntilUnlock: Int {
        max(0, Int(unlockDate.timeIntervalSinceNow / 86400))
    }
}

struct CapsuleResponse: Identifiable, Codable {
    let id: UUID
    let authorId: UUID
    var content: String
    var timestamp: Date
}

struct UniverseBadge: Identifiable, Codable {
    let id: UUID
    var name: String
    var iconName: String
    var earnedDate: Date
    var description: String
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    var name: String
    var iconName: String
    var isUnlocked: Bool
    var unlockDate: Date?
}

struct DailyChallenge: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var points: Int
    var isCompleted: Bool
}

struct ChoicePoll: Identifiable {
    let id: UUID
    var question: String
    var optionA: String
    var optionB: String
    var votesA: Int
    var votesB: Int
    var authorId: UUID
}

struct Message: Identifiable, Codable {
    let id: UUID
    let senderId: UUID
    var content: String
    var timestamp: Date
    var isRead: Bool
}