import Foundation

// MARK: - Life Path (Life Dimension)
enum LifePath: String, CaseIterable, Codable, Identifiable {
    case career = "Career"
    case family = "Family"
    case creativity = "Creativity"
    case adventure = "Adventure"
    case finance = "Finance"
    case health = "Health"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .career: return "briefcase.fill"
        case .family: return "house.fill"
        case .creativity: return "paintpalette.fill"
        case .adventure: return "map.fill"
        case .finance: return "dollarsign.circle.fill"
        case .health: return "heart.fill"
        }
    }
    
    var color: String {
        switch self {
        case .career: return "9B8FE8"
        case .family: return "6EE7B7"
        case .creativity: return "F472B6"
        case .adventure: return "FB923C"
        case .finance: return "FCD34D"
        case .health: return "EF4444"
        }
    }
}

// MARK: - Personality Trait
struct PersonalityTrait: Identifiable, Codable {
    let id: UUID
    let name: String
    let emoji: String
    
    init(id: UUID = UUID(), name: String, emoji: String) {
        self.id = id
        self.name = name
        self.emoji = emoji
    }
    
    static let allTraits: [PersonalityTrait] = [
        PersonalityTrait(name: "Ambitious", emoji: "🔥"),
        PersonalityTrait(name: "Creative", emoji: "🎨"),
        PersonalityTrait(name: "Cautious", emoji: "🛡️"),
        PersonalityTrait(name: "Adventurous", emoji: "🚀"),
        PersonalityTrait(name: "Compassionate", emoji: "💚"),
        PersonalityTrait(name: "Analytical", emoji: "🔬"),
        PersonalityTrait(name: "Optimistic", emoji: "☀️"),
        PersonalityTrait(name: "Reserved", emoji: "🌙"),
        PersonalityTrait(name: "Energetic", emoji: "⚡"),
        PersonalityTrait(name: "Thoughtful", emoji: "🤔")
    ]
}

// MARK: - Talent
struct Talent: Identifiable, Codable {
    let id: UUID
    let name: String
    let level: Int // 1-5
    
    init(id: UUID = UUID(), name: String, level: Int) {
        self.id = id
        self.name = name
        self.level = max(1, min(5, level))
    }
    
    static let availableTalents: [String] = [
        "Leadership", "Communication", "Problem Solving", "Creativity",
        "Empathy", "Strategic Thinking", "Technical Skills", "Artistic",
        "Athletic", "Musical", "Writing", "Teaching", "Management",
        "Analysis", "Innovation", "Teamwork"
    ]
}

// MARK: - Universe Background Theme
struct UniverseTheme: Identifiable, Codable {
    let id: UUID
    let name: String
    let gradientColors: [String]
    let icon: String
    
    init(id: UUID = UUID(), name: String, gradientColors: [String], icon: String) {
        self.id = id
        self.name = name
        self.gradientColors = gradientColors
        self.icon = icon
    }
    
    static let allThemes: [UniverseTheme] = [
        UniverseTheme(name: "Cosmic Void", gradientColors: ["0F0F14", "1a1a2e"], icon: "sparkles"),
        UniverseTheme(name: "Aurora", gradientColors: ["10B981", "6EE7B7"], icon: "aurora"),
        UniverseTheme(name: "Sunset Dreams", gradientColors: ["F59E0B", "EF4444"], icon: "sunset.fill"),
        UniverseTheme(name: "Ocean Depth", gradientColors: ["0EA5E9", "1e3a5f"], icon: "water.waves"),
        UniverseTheme(name: "Forest Mystery", gradientColors: ["22C55E", "064E3B"], icon: "leaf.fill"),
        UniverseTheme(name: "Galaxy", gradientColors: ["9B8FE8", "6366F1"], icon: "galaxy.fill")
    ]
}

// MARK: - Parallel Self
struct ParallelSelf: Identifiable, Codable {
    let id: UUID
    var name: String
    var universeName: String
    var lifePaths: [LifePath]
    var personalityTraits: [PersonalityTrait]
    var talents: [Talent]
    var powerWords: [String]
    var alternateHistory: String
    var universeTheme: UniverseTheme
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String = "My Parallel Self",
        universeName: String = "Universe A",
        lifePaths: [LifePath] = [],
        personalityTraits: [PersonalityTrait] = [],
        talents: [Talent] = [],
        powerWords: [String] = [],
        alternateHistory: String = "",
        universeTheme: UniverseTheme = UniverseTheme.allThemes[0],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.universeName = universeName
        self.lifePaths = lifePaths
        self.personalityTraits = personalityTraits
        self.talents = talents
        self.powerWords = powerWords
        self.alternateHistory = alternateHistory
        self.universeTheme = universeTheme
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Time Capsule
struct TimeCapsule: Identifiable, Codable {
    let id: UUID
    var title: String
    var message: String
    var recipientSelfId: UUID? // Which parallel self this is for
    var createdAt: Date
    var unlockDate: Date
    var privacy: CapsulePrivacy
    var isOpened: Bool
    
    init(
        id: UUID = UUID(),
        title: String = "",
        message: String = "",
        recipientSelfId: UUID? = nil,
        createdAt: Date = Date(),
        unlockDate: Date = Date().addingTimeInterval(86400 * 30), // Default 30 days
        privacy: CapsulePrivacy = .privateCapsule,
        isOpened: Bool = false
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.recipientSelfId = recipientSelfId
        self.createdAt = createdAt
        self.unlockDate = unlockDate
        self.privacy = privacy
        self.isOpened = isOpened
    }
    
    var isUnlocked: Bool {
        Date() >= unlockDate
    }
}

enum CapsulePrivacy: String, CaseIterable, Codable {
    case privateCapsule = "Private"
    case friendsOnly = "Friends Only"
    case publicCapsule = "Public"
    
    var icon: String {
        switch self {
        case .privateCapsule: return "lock.fill"
        case .friendsOnly: return "person.2.fill"
        case .publicCapsule: return "globe"
        }
    }
}

// MARK: - User Profile
struct UserProfile: Codable {
    var id: UUID
    var displayName: String
    var parallelSelves: [ParallelSelf]
    var capsules: [TimeCapsule]
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        displayName: String = "Explorer",
        parallelSelves: [ParallelSelf] = [],
        capsules: [TimeCapsule] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.parallelSelves = parallelSelves
        self.capsules = capsules
        self.createdAt = createdAt
    }
}