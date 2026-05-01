import XCTest
@testable import ParallelU

final class ParallelUTests: XCTestCase {
    
    // MARK: - Models Tests
    
    func testParallelSelfCreation() {
        let parallelSelf = ParallelSelf(
            name: "Career Me",
            universeName: "Universe B",
            lifePaths: [.career, .finance],
            personalityTraits: Array(PersonalityTrait.allTraits.prefix(2)),
            talents: [Talent(name: "Leadership", level: 5)],
            powerWords: ["Ambitious", "Focused", "Driven"],
            alternateHistory: "Chose to focus on career instead of family",
            universeTheme: UniverseTheme.allThemes[0]
        )
        
        XCTAssertEqual(parallelSelf.name, "Career Me")
        XCTAssertEqual(parallelSelf.universeName, "Universe B")
        XCTAssertEqual(parallelSelf.lifePaths.count, 2)
        XCTAssertEqual(parallelSelf.powerWords.count, 3)
    }
    
    func testLifePathIcons() {
        XCTAssertEqual(LifePath.career.icon, "briefcase.fill")
        XCTAssertEqual(LifePath.family.icon, "house.fill")
        XCTAssertEqual(LifePath.creativity.icon, "paintpalette.fill")
        XCTAssertEqual(LifePath.adventure.icon, "map.fill")
        XCTAssertEqual(LifePath.finance.icon, "dollarsign.circle.fill")
        XCTAssertEqual(LifePath.health.icon, "heart.fill")
    }
    
    func testTimeCapsuleUnlockLogic() {
        let futureCapsule = TimeCapsule(
            title: "Future Message",
            message: "Hello from the past!",
            unlockDate: Date().addingTimeInterval(86400 * 30) // 30 days from now
        )
        
        XCTAssertFalse(futureCapsule.isUnlocked)
        
        let pastCapsule = TimeCapsule(
            title: "Past Message",
            message: "This should be unlocked",
            unlockDate: Date().addingTimeInterval(-86400) // Yesterday
        )
        
        XCTAssertTrue(pastCapsule.isUnlocked)
    }
    
    func testCapsulePrivacy() {
        XCTAssertEqual(CapsulePrivacy.allCases.count, 3)
        XCTAssertEqual(CapsulePrivacy.privateCapsule.icon, "lock.fill")
        XCTAssertEqual(CapsulePrivacy.friendsOnly.icon, "person.2.fill")
        XCTAssertEqual(CapsulePrivacy.publicCapsule.icon, "globe")
    }
    
    func testUniverseTheme() {
        XCTAssertEqual(UniverseTheme.allThemes.count, 6)
        XCTAssertEqual(UniverseTheme.allThemes[0].name, "Cosmic Void")
    }
    
    func testTalentLevelBounds() {
        let normalTalent = Talent(name: "Leadership", level: 3)
        XCTAssertEqual(normalTalent.level, 3)
        
        let overMaxTalent = Talent(name: "Art", level: 10)
        XCTAssertEqual(overMaxTalent.level, 5) // Capped at 5
        
        let underMinTalent = Talent(name: "Music", level: -2)
        XCTAssertEqual(underMinTalent.level, 1) // Minimum 1
    }
    
    func testUserProfileDefaultValues() {
        let profile = UserProfile()
        XCTAssertEqual(profile.displayName, "Explorer")
        XCTAssertTrue(profile.parallelSelves.isEmpty)
        XCTAssertTrue(profile.capsules.isEmpty)
    }
    
    func testPersonalityTraitCount() {
        XCTAssertEqual(PersonalityTrait.allTraits.count, 10)
    }
}
