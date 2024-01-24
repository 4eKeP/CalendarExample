//
//  EventsStore.swift
//  CalendarExample
//
//  Created by admin on 22.01.2024.
//

import Foundation
import EventKit
import EventKitUI

final class DateBase {
    
    enum EventType {
        case event, none
    }
    
    public static let shared = DateBase()
    
    private var eventStore = EKEventStore()
    
    private let events: [DateComponents] = [
        DateComponents(calendar: .current, year: 2024, month: 1, day: 22),
        DateComponents(calendar: .current, year: 2024, month: 1, day: 23),
        DateComponents(calendar: .current, year: 2024, month: 1, day: 24),
        DateComponents(calendar: .current, year: 2024, month: 1, day: 25),
    ]
    
    
    func eventsAt(date: DateComponents) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        
        guard let startDate = calendar.date(from: date) else {
            assertionFailure("failed to get startDate")
            return false
        }
        
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        guard let endDate = calendar.date(byAdding: oneDayComponents, to: startDate) else {
            assertionFailure("failed to get endDate")
            return false
        }
     //   calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                  end: endDate,
                                                  calendars: nil) // ищет во всех календарях
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        return !eventKitEvents.isEmpty ? true : false
    }
    
    private func eventStatus(date: DateComponents) -> EventType {
        if eventsAt(date: date) {
            return EventType.event
        }
        return EventType.none
    }
    
    func eventOnCalendar(date: DateComponents) -> UICalendarView.Decoration? {
        let event = eventStatus(date: date)
        
        switch event {
        case .event:
            return .default()
        case .none:
            return nil
        }
    }
    
}
