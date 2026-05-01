import Foundation

final class DataManager {
    static let shared = DataManager()
    
    private let appGroupId = "group.com.ggsheng.ParallelU"
    private let userProfileKey = "userProfile"
    
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupId)
    }
    
    private init() {}
    
    // MARK: - User Profile
    
    func saveUserProfile(_ profile: UserProfile) {
        guard let defaults = sharedDefaults else { return }
        if let encoded = try? JSONEncoder().encode(profile) {
            defaults.set(encoded, forKey: userProfileKey)
            defaults.synchronize()
        }
    }
    
    func loadUserProfile() -> UserProfile {
        guard let defaults = sharedDefaults,
              let data = defaults.data(forKey: userProfileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return UserProfile()
        }
        return profile
    }
    
    func updateProfile(_ update: (inout UserProfile) -> Void) {
        var profile = loadUserProfile()
        update(&profile)
        saveUserProfile(profile)
    }
    
    // MARK: - Parallel Selves
    
    func addParallelSelf(_ self_: ParallelSelf) {
        updateProfile { profile in
            profile.parallelSelves.append(self_)
        }
    }
    
    func updateParallelSelf(_ self_: ParallelSelf) {
        updateProfile { profile in
            if let index = profile.parallelSelves.firstIndex(where: { $0.id == self_.id }) {
                var updated = self_
                updated.updatedAt = Date()
                profile.parallelSelves[index] = updated
            }
        }
    }
    
    func deleteParallelSelf(id: UUID) {
        updateProfile { profile in
            profile.parallelSelves.removeAll { $0.id == id }
        }
    }
    
    func getParallelSelf(id: UUID) -> ParallelSelf? {
        loadUserProfile().parallelSelves.first { $0.id == id }
    }
    
    // MARK: - Time Capsules
    
    func addCapsule(_ capsule: TimeCapsule) {
        updateProfile { profile in
            profile.capsules.append(capsule)
        }
    }
    
    func updateCapsule(_ capsule: TimeCapsule) {
        updateProfile { profile in
            if let index = profile.capsules.firstIndex(where: { $0.id == capsule.id }) {
                profile.capsules[index] = capsule
            }
        }
    }
    
    func deleteCapsule(id: UUID) {
        updateProfile { profile in
            profile.capsules.removeAll { $0.id == id }
        }
    }
    
    func openCapsule(id: UUID) {
        updateProfile { profile in
            if let index = profile.capsules.firstIndex(where: { $0.id == id }) {
                profile.capsules[index].isOpened = true
            }
        }
    }
    
    func getUnlockedCapsules() -> [TimeCapsule] {
        loadUserProfile().capsules.filter { $0.isUnlocked && !$0.isOpened }
    }
    
    func getUpcomingCapsules(withinDays: Int = 7) -> [TimeCapsule] {
        let now = Date()
        let future = now.addingTimeInterval(Double(withinDays) * 86400)
        return loadUserProfile().capsules.filter { capsule in
            !capsule.isOpened && capsule.unlockDate > now && capsule.unlockDate <= future
        }
    }
    
    // MARK: - Debug / Reset
    
    func resetAllData() {
        saveUserProfile(UserProfile())
    }
}