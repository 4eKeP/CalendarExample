//
//  AlarmControl.swift
//  CalendarExample
//
//  Created by admin on 13.02.2024.
//

import Foundation
import EventKit
import UserNotifications

final class AlarmControl {
    // функция для добавления alarm для эвента и его убиранием, и получение самого эвента
    // добавить сравнение списков алярмов что бы не добавлять повторно 
   // if hasAlarm не добавлять алярм
        
    func alarmWasDeleted(event: EKEvent) {
        guard let noAlarms = event.alarms?.isEmpty else { return assertionFailure("Failed to receive isEmpty from alarms")}
        if event.hasAlarms {
            
            event.alarms?.forEach{
                
                let content = addContent(event: event)
                
                guard let safeAbsoluteDate = $0.absoluteDate else { return }
                let safeDate = safeAbsoluteDate + $0.relativeOffset
                let trigger = addTrigger(date: safeDate, event: event)
                
                let request = addRequest(eventForID: event, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func addTrigger(date: Date, event: EKEvent) -> UNCalendarNotificationTrigger {
        let dateForNotification = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateForNotification, repeats: event.hasRecurrenceRules)
        return trigger
    }
    
    func addContent(event: EKEvent) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.sound = .default
        content.body = event.description
        return content
    }
    
    func addRequest(eventForID event: EKEvent, content: UNMutableNotificationContent, trigger:  UNCalendarNotificationTrigger) -> UNNotificationRequest {
        return UNNotificationRequest(identifier: event.calendarItemIdentifier, content: content, trigger: trigger)
        
    }
}
