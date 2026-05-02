import XCTest
@testable import ParallelU

final class ParallelUTests: XCTestCase {
    func testAppInitialization() throws {
        let appState = AppState()
        XCTAssertNotNil(appState.currentUser)
        XCTAssertEqual(appState.selectedTab, .home)
        XCTAssertTrue(appState.isDarkMode)
    }
    
    func testCreateParallelSelf() throws {
        let appState = AppState()
        let initialCount = appState.parallelSelves.count
        
        appState.createParallelSelf(
            name: "Test Universe",
            lifePath: .career,
            personality: "Ambitious",
            background: "Cosmic Purple",
            powerWords: ["Focus", "Drive", "Success"],
            emotionPalette: [.calm, .energetic],
            talents: ["Leadership", "Strategy"]
        )
        
        XCTAssertEqual(appState.parallelSelves.count, initialCount + 1)
    }
    
    func testCreateCapsule() throws {
        let appState = AppState()
        let initialCount = appState.capsules.count
        
        appState.createCapsule(content: "Test capsule", unlockDays: 30, privacy: .privateCapsule)
        
        XCTAssertEqual(appState.capsules.count, initialCount + 1)
    }
    
    func testLifePath() throws {
        let career = LifePath.career
        XCTAssertEqual(career.rawValue, "Career")
        XCTAssertEqual(career.icon, "briefcase.fill")
    }
}