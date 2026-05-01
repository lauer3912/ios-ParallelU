import SwiftUI

struct ContentView: View {
    @State private var hasRequestedNotification = false
    
    var body: some View {
        MainTabView()
            .onAppear {
                setupNotifications()
            }
    }
    
    private func setupNotifications() {
        guard !hasRequestedNotification else { return }
        hasRequestedNotification = true
        
        NotificationService.shared.requestPermission { granted in
            if granted {
                // Schedule daily quote notification at 9 AM
                NotificationService.shared.scheduleDailyQuoteNotification(at: 9, minute: 0)
                // Reschedule any pending capsule notifications
                NotificationService.shared.rescheduleAllCapsuleNotifications()
            }
        }
    }
}

#Preview {
    ContentView()
}
