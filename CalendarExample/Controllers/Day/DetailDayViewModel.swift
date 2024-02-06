//
//  DetailDayViewModel.swift
//  CalendarExample
//
//  Created by admin on 01.02.2024.
//

import Foundation
import EventKit

protocol DetailDayViewModelProtocol {
    var delegate: DetailedDayViewControllerDelegate? { get set }
    
    var dateBase: DateBase { get }
    
    func cancelButtonPress()
    
    func eventsForDate(_ date: Date, calendar: Calendar) -> [EventStoreWrapper]
    
    func addDateToUpdate(date: Date)
    
    func createNewEvent(at date: Date, calendar: Calendar) -> EventStoreWrapper
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    weak var delegate: DetailedDayViewControllerDelegate?
    
    let dateBase = DateBase.shared
    
    func cancelButtonPress() {
        delegate?.detailedDayViewController()
    }
    
    func eventsForDate(_ date: Date, calendar: Calendar) -> [EventStoreWrapper] {
        let startDate = date
        
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = dateBase.eventStore.predicateForEvents(withStart: startDate,
                                                  end: endDate,
                                                  calendars: nil) // ищет во всех календарях
        
        let eventKitEvents = dateBase.eventStore.events(matching: predicate)
        
        
        let calendarKitEvents = eventKitEvents.map(EventStoreWrapper.init)
        
        return calendarKitEvents
    }
    
    func addDateToUpdate(date: Date) {
        dateBase.addDateToUpdate(date: date)
    }
    
    func getSelectedDate() -> Date {
        dateBase.getSelectedDate()
    }
    
    func createNewEvent(at date: Date, calendar: Calendar) -> EventStoreWrapper {
//        let newEvent = EKEvent(eventStore: eventStore)
//        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        
//        var components = DateComponents()
//        components.hour = 1
//        let endDate = calendar.date(byAdding: components, to: date)
//        
//        newEvent.startDate = date
//        newEvent.endDate = endDate
//        newEvent.title = newEventTitle
        
        let newEvent = dateBase.createNewEvent(at: date, calendar: calendar)
        
        let newESWrapepr = EventStoreWrapper(EKEvent: newEvent)
        newESWrapepr.editedEvent = newESWrapepr
        return newESWrapepr
    }
    
}
