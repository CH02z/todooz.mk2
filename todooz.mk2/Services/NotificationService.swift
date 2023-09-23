//
//  NotificationService.swift
//  todooz.mk2
//
//  Created by Chris Zimmermann on 23.09.23.
//

import Foundation
import UserNotifications

class NotificationHandler : NSObject, UNUserNotificationCenterDelegate{
    static let shared = NotificationHandler()
    
    /** Handle notification when app is in background */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:
                                UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notiName = Notification.Name(response.notification.request.identifier)
        NotificationCenter.default.post(name:notiName , object: response.notification.request.content)
        completionHandler()
    }
    
    /** Handle notification when the app is in foreground */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let notiName = Notification.Name( notification.request.identifier )
        NotificationCenter.default.post(name:notiName , object: notification.request.content)
        completionHandler(.sound)
    }
    
    // RequestPerpissions
    func requestPermission(_ delegate : UNUserNotificationCenterDelegate? = nil ,
                           onDeny handler :  (()-> Void)? = nil){  // an optional onDeny handler is better here,
        // so there is an option not to provide one, have one only when needed
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings(completionHandler: { settings in
            
            if settings.authorizationStatus == .denied {
                if let handler = handler {
                    handler()
                }
                return
            }
            
            if settings.authorizationStatus != .authorized  {
                center.requestAuthorization(options: [.alert, .sound, .badge]) {
                    _ , error in
                    
                    if let error = error {
                        print("error handling \(error.localizedDescription)")
                    }
                }
            }
            
        })
        center.delegate = delegate ?? self
    }
    
    
    func addNotification(id : String,
                         title : String,
                         subtitle : String ,
                         sound : UNNotificationSound = UNNotificationSound.default,
                         trigger : UNNotificationTrigger =
                         UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotificationWithDate(id: String,
                                      title : String,
                                      subtitle : String,
                                      sound : UNNotificationSound = UNNotificationSound.default,
                                      date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = sound
        
        let triggerDate =  Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(
                        dateMatching: triggerDate,
                        repeats: false
                )
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("Nitification set for \(date) for task \(subtitle) with Notification id \(id)")
    }
    
    
    func removeNotifications(ids : [String]){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        print("Notification with ID: \(ids) was deleted")
    }
    
    
}
