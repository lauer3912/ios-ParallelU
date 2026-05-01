import XCTest

final class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!
    var outputDir: String { "/tmp/parallelu_screenshots/" }
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        
        // Create output directory
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: outputDir) {
            try? fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        }
        
        app.launchArguments = ["--reset-app"]
        app.launch()
        sleep(1)
    }
    
    override func tearDown() {
        app.terminate()
        super.tearDown()
    }
    
    func capture(_ filename: String) {
        sleep(1)
        let snapshot = app.windows.firstMatch.screenshot()
        let data = snapshot.pngRepresentation
        let url = URL(fileURLWithPath: outputDir + filename)
        try? data.write(to: url)
        print("Captured: \(filename)")
    }
    
    // MARK: - Screenshot Functions
    
    func screenshotHome() {
        // SwiftUI TabView uses staticText for tab labels
        app.tabBars.buttons["Home"].tap()
        sleep(2)
        capture("01_home.png")
    }
    
    func screenshotExplore() {
        app.tabBars.buttons["Explore"].tap()
        sleep(2)
        capture("02_explore.png")
    }
    
    func screenshotCapsules() {
        app.tabBars.buttons["Capsules"].tap()
        sleep(2)
        capture("03_capsules.png")
    }
    
    func screenshotProfile() {
        app.tabBars.buttons["Profile"].tap()
        sleep(2)
        capture("04_profile.png")
    }
    
    // MARK: - Test
    
    func testScreenshotAllTabs() {
        screenshotHome()
        screenshotExplore()
        screenshotCapsules()
        screenshotProfile()
    }
}
