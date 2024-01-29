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
    
    private var selectedDate = Date()
    
    private var datesToUpdate = Set<DateComponents>()
    
    public static let shared = DateBase()
    
    private var eventStore = EKEventStore()
    
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
    
    func selectedDate(date: Date) {
        selectedDate = date
    }
    
    func getSelectedDate() -> Date {
        selectedDate
    }
    
    func addDateToUpdate(date: Date) {
        let dateComponentsFromDate = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: date)
        datesToUpdate.insert(dateComponentsFromDate)
        print("set of dates \(datesToUpdate)")
    }
    
    func getDatesToUpdate() -> [DateComponents] {
        let arrayOfDates = Array(datesToUpdate)
        print("array dates was called \(arrayOfDates)")
        return arrayOfDates
    }
    
    func cancelButtonPressed() {
        
    }
    
    func deleteDatesToUpdate() {
        datesToUpdate.removeAll()
    }
    
}
