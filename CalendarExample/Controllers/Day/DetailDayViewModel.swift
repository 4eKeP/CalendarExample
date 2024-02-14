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
    
    func addNotificationFirstTime(event: EKEvent)
    
    func deleteNotifications(for event: EKEvent)
    
    func setOldEventOnEdit(event: EKEvent)
    
    func eventStoreHasChanged()
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    weak var delegate: DetailedDayViewControllerDelegate?
    
    let dateBase = DateBase.shared
    
    private let notificationControl = NotificationControl()
    
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
        
        let newEvent = dateBase.createNewEvent(at: date, calendar: calendar)
        
        let newESWrapepr = EventStoreWrapper(EKEvent: newEvent)
        newESWrapepr.editedEvent = newESWrapepr
        return newESWrapepr
    }
    
    func setOldEventOnEdit(event: EKEvent) {
        dateBase.setOldEventOnEdit(event: event)
    }
    
    func getOldEventOnEdit() -> EKEvent? {
        dateBase.getOldEventOnEdit()
    }
    
    func addNotificationFirstTime(event: EKEvent) {
        notificationControl.addNotificationFirstTime(event: event)
    }
    
    func updateNotifications(oldEvent: EKEvent, newEvent: EKEvent) {
        notificationControl.updateNotifications(oldEvent: oldEvent, newEvent: newEvent)
    }
    
    func getNewEventFromOldOnEditFromDB() -> EKEvent? {
        dateBase.getNewEventFromOldOnEditFromDB()
    }
    
    func eventStoreHasChanged() {
        if let newEvent = getNewEventFromOldOnEditFromDB(), let oldEvent = getOldEventOnEdit() {
            updateNotifications(oldEvent: oldEvent, newEvent: newEvent)
        }
    }
    
    func deleteNotifications(for event: EKEvent) {
        notificationControl.deleteNotifications(for: event)
    }
    
    func deleteAllNotifications() {
        notificationControl.deleteAllNotifications()
    }
    
}
