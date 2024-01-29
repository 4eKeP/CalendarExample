//
//  ViewController.swift
//  CalendarExample
//
//  Created by admin on 20.01.2024.
//

import UIKit
import CalendarKit
import EventKit
import EventKitUI

protocol DetailedDayViewControllerDelegate: AnyObject {
    func detailedDayViewController(_ viewController: DetailedDayViewController, withDates dateComponets: [DateComponents])
}

final class DetailedDayViewController: DayViewController {
    
    private var datesToUpdate = Set<DateComponents>()

    private var eventStore = EKEventStore()
    
    private let dateBase = DateBase.shared
    
    private let calendarTitle = "Calendar"
    
    private let newEventTitle = "New event"
    
    weak var detailDelegate: DetailedDayViewControllerDelegate?
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        requestAccessToCalendar()
        
        subscribeToNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  navigationController?.setToolbarHidden(true, animated: false)
        move(to: dateBase.getSelectedDate())
    }
    
    @objc func cancelButtonPressed() {
        
//        var arrayOfDateComponents: [DateComponents] = []
//        let arrayOfDates = Array(datesToUpdate)
//        arrayOfDates.forEach { date in
//            arrayOfDateComponents.append(Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: date))
//        }
        detailDelegate?.detailedDayViewController(self, withDates: Array(datesToUpdate))
        
        dismiss(animated: true)
    }
    
    
    //MARK: - DayViewDataSource

        
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                  end: endDate,
                                                  calendars: nil) // ищет во всех календарях
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        
        let calendarKitEvents = eventKitEvents.map(EventStoreWrapper.init)
        
        return calendarKitEvents
        
    }
        
    //MARK: - DayViewDelegate
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        
      //  datesToUpdate.insert(Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: date))
        
        dateBase.addDateToUpdate(date: date)
        print(dateBase.getDatesToUpdate())
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        endEventEditing()
        dateBase.addDateToUpdate(date: date)
        let newEventStoreWrapper = createNewEvent(at: date)
        create(event: newEventStoreWrapper, animated: true)
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? EventStoreWrapper else {
            return
        }
        endEventEditing()
        beginEditing(event: descriptor, animated: true)
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EventStoreWrapper else { return }
        if let originalEvent = event.editedEvent {
            editingEvent.commitEditing()
            
            if originalEvent === editingEvent {
                presentEditingViewForEvent(editingEvent.event)
            } else {
                try! eventStore.save(editingEvent.event, span: .thisEvent)
            }
        }
        reloadData()
    }
    
    //MARK: - Event selection
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EventStoreWrapper else {
            return
        }
        presentDetailViewForEvent(ckEvent.event)
    }
    
    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventController = EKEventViewController()
        eventController.event = ekEvent
        eventController.allowsCalendarPreview = true
        eventController.allowsEditing  = true
        dateBase.addDateToUpdate(date: ekEvent.startDate)
        navigationController?.pushViewController(eventController, animated: true)
    }
    
    //MARK: - Event editing

    
    private func createNewEvent(at date: Date) -> EventStoreWrapper {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var components = DateComponents()
        components.hour = 1
        let endDate = calendar.date(byAdding: components, to: date)
        
        newEvent.startDate = date
        newEvent.endDate = endDate
        newEvent.title = newEventTitle
        
        let newESWrapepr = EventStoreWrapper(EKEvent: newEvent)
        newESWrapepr.editedEvent = newESWrapepr
        return newESWrapepr
    }
    
    
    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true)
    }
    
}

//MARK: - Access request to Events

private extension DetailedDayViewController {
    
    func requestAccessToCalendar() {
        let complitionHandler: EKEventStoreRequestAccessCompletionHandler = {
            [weak self] granted, error in
            // почему то complition handler не запускаеться на главном потоке автоматически
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                self.subscribeToNotifications()
                self.reloadData()
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: complitionHandler)
        } else {
            eventStore.requestAccess(to: .event, completion: complitionHandler)
        }
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }
    
    func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
}

//MARK: - EKEventEditViewDelegate

extension DetailedDayViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        endEventEditing()
        reloadData()
        controller.dismiss(animated: true)
    }
    
    
}

//MARK: - UI Config

private extension DetailedDayViewController {
    
    func setupUI(){
        configNavBar()
    }
    
    func configNavBar() {
        title = calendarTitle
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
}

