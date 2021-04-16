import SwiftUI
import UserNotifications

public func NotificationActivate() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        print("Permission granted: \(granted)")
        guard granted else { return }
        
        getNotificationSettings()
    }
}

fileprivate func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}


