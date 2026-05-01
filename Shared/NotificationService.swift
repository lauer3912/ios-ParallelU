import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    
    private let center = UNUserNotificationCenter.current()
    
    private init() {}
    
    // MARK: - Permission
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func checkPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    // MARK: - Capsule Reminder Notifications
    
    func scheduleCapsuleUnlockReminder(for capsule: TimeCapsule) {
        let content = UNMutableNotificationContent()
        content.title = "🌌 Time Capsule Ready!"
        content.body = capsule.title.isEmpty ? "A message from your parallel self is waiting to be opened." : "\"\(capsule.title)\" is ready to open."
        content.sound = .default
        content.categoryIdentifier = "CAPSULE_UNLOCK"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: capsule.unlockDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "capsule_\(capsule.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule capsule notification: \(error)")
            }
        }
    }
    
    func scheduleCapsuleUpcomingReminder(for capsule: TimeCapsule, daysBeforeUnlock: Int) {
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: -daysBeforeUnlock, to: capsule.unlockDate),
              reminderDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "⏰ Capsule Unlocking Soon"
        content.body = "Your time capsule \"\(capsule.title.isEmpty ? "Time Capsule" : capsule.title)\" will unlock in \(daysBeforeUnlock) day\(daysBeforeUnlock > 1 ? "s" : "")."
        content.sound = .default
        content.categoryIdentifier = "CAPSULE_UPCOMING"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "capsule_upcoming_\(capsule.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule upcoming capsule notification: \(error)")
            }
        }
    }
    
    // MARK: - Daily Parallel Quote Notification
    
    func scheduleDailyQuoteNotification(at hour: Int = 9, minute: Int = 0) {
        let quotes = [
            "What choice would your parallel self make today? 🌌",
            "Another universe version of you made a decision. What was it? ✨",
            "Time capsules hold messages from other paths. Check yours! 💫",
            "Your parallel selves are waiting to share their stories. 🔮",
            "Today is a new universe. What will you create? 🚀",
            "The parallel you chose differently. Would you? 🌠"
        ]
        
        cancelDailyQuoteNotification()
        
        let content = UNMutableNotificationContent()
        content.title = "🌌 ParallelU"
        content.body = quotes.randomElement() ?? quotes[0]
        content.sound = .default
        content.categoryIdentifier = "DAILY_QUOTE"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "daily_quote",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule daily quote: \(error)")
            }
        }
    }
    
    // MARK: - Parallel Self Creation Reminder
    
    func scheduleCreateParallelReminder(afterDays: Int = 2) {
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: afterDays, to: Date()) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "✨ Create Another You"
        content.body = "You haven't created a new parallel self in a while. Explore a different universe path!"
        content.sound = .default
        content.categoryIdentifier = "CREATE_PARALLEL"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "create_parallel_reminder",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule create parallel reminder: \(error)")
            }
        }
    }
    
    // MARK: - Cancel Notifications
    
    func cancelCapsuleNotification(capsuleId: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: [
            "capsule_\(capsuleId.uuidString)",
            "capsule_upcoming_\(capsuleId.uuidString)"
        ])
    }
    
    func cancelDailyQuoteNotification() {
        center.removePendingNotificationRequests(withIdentifiers: ["daily_quote"])
    }
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    // MARK: - Reschedule All
    
    func rescheduleAllCapsuleNotifications() {
        let capsules = DataManager.shared.loadUserProfile().capsules.filter { !$0.isOpened }
        
        for capsule in capsules {
            // Schedule unlock notification
            if !capsule.isUnlocked {
                scheduleCapsuleUnlockReminder(for: capsule)
                
                // Schedule 1-day reminder
                scheduleCapsuleUpcomingReminder(for: capsule, daysBeforeUnlock: 1)
                
                // Schedule 7-day reminder if unlock is more than 7 days away
                if capsule.unlockDate > Date().addingTimeInterval(86400 * 7) {
                    scheduleCapsuleUpcomingReminder(for: capsule, daysBeforeUnlock: 7)
                }
            }
        }
    }
}
