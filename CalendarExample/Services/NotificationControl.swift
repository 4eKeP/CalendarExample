//
//  NotificationControl.swift
//  CalendarExample
//
//  Created by admin on 13.02.2024.
//

import Foundation
import EventKit
import UserNotifications

final class NotificationControl {
    func addNotificationFirstTime(event: EKEvent) {
        if event.hasAlarms {
            event.alarms?.forEach{
                addNotification(event: event, alarm: $0)
            }
        } else {
            return
        }
    }
    
    func updateNotifications(oldEvent: EKEvent, newEvent: EKEvent) {
        if newEvent.hasAlarms {
            deleteNotifications(for: oldEvent)
            newEvent.alarms?.forEach{
                addNotification(event: newEvent, alarm: $0)
            }
        } else {
            deleteNotifications(for: oldEvent)
        }
    }
    
    func deleteNotifications(for event: EKEvent) {
        guard let alerts = event.alarms else { return }
        var oldAlertsHash: [String] = []
        alerts.forEach {
            oldAlertsHash.append(String($0.hash))
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: oldAlertsHash)
    }
    
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    //MARK: - Private Func
    
    private func addNotification(event: EKEvent, alarm: EKAlarm) {
        let content = addContent(event: event)
        
        guard let safeAbsoluteDate = alarm.absoluteDate else { return }
        let safeDate = safeAbsoluteDate + alarm.relativeOffset
        let trigger = addTrigger(date: safeDate, event: event)
        
        let request = addRequest(alertHash: alarm.hash, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func addTrigger(date: Date, event: EKEvent) -> UNCalendarNotificationTrigger {
        let dateForNotification = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateForNotification, repeats: event.hasRecurrenceRules)
        return trigger
    }
    
    private func addContent(event: EKEvent) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.sound = .default
        content.body = event.description
        return content
    }
    
    private func addRequest(alertHash hash: Int, content: UNMutableNotificationContent, trigger:  UNCalendarNotificationTrigger) -> UNNotificationRequest {
        return UNNotificationRequest(identifier: String(hash), content: content, trigger: trigger)
    }
}
