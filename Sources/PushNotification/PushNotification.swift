import SwiftUI
import UIKit
import UserNotifications

public class PushNotification {
    
    private var authenticationMethod: AuthenticationMethod
    private var url: URL
    private static var shared: PushNotification?
    private var deviceToken: String?
    
    public enum AuthenticationMethod {
        case user(id: UUID)
        case jwt(token: String)
        case none
    }
    
    private init(authenticationMethod: AuthenticationMethod, url: URL) {
        self.authenticationMethod = authenticationMethod
        self.url = url
    }
    
    public static func notificationActivate(_ url: String, authenticationMethod: AuthenticationMethod) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
                
                guard let url = URL(string: url) else {
                    return
                }
                
                shared = PushNotification(authenticationMethod: authenticationMethod, url: url)
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    public static func registrateDevice(device token: Data) {
        
        guard shared != nil else {
            return
            
        }
        
        let tokenParts = token.map { data in String(format: "%02.2hhx", data) }
        let deviceToken = tokenParts.joined()
        shared!.deviceToken = deviceToken
        
        switch shared!.authenticationMethod {
        case .jwt(let token):
            RegistrationDeviceJWT(device: deviceToken, token: token).request(shared!.url)
            break
            
        case .user(let id):
            RegistrationDeviceUser(device: deviceToken, id: id).request(shared!.url)
            break
        
        case .none:
            RegistrationDeviceNone(device: deviceToken).request(shared!.url)
            break
        }
    }
    
    public static func removeDevice() {
        
        guard shared != nil, shared!.deviceToken != nil else {
            return
            
        }
        
        switch shared!.authenticationMethod {
        case .jwt(_):
            break
            
        case .user(let id):
            RemoveDeviceUser(device: shared!.deviceToken!, id: id).request(shared!.url)
            break
        
        case .none:
            break
        }
        
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}
