//
//  NotificationCenterManager.swift
//  PookPool
//
//  Created by Assa Bentzur on 02/07/2022.
//

import Foundation
import NotificationCenter

@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // Delegate function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
    
    func requestAuthorization() async throws {
       try await notificationCenter
            .requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await  notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .defaultCritical
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: localNotification.timeInterval, repeats: localNotification.repeats)
        
        let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
        try? await notificationCenter.add(request)
    }
    
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
