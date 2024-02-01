//
//  MonthViewModel.swift
//  CalendarExample
//
//  Created by admin on 31.01.2024.
//

import UIKit
import EventKit

protocol MonthViewModelProtocol {
    
    var OnChange: (()->Void)? { get set }
    
    var eventStore: EKEventStore { get set }
    
    func getDatesToUpdate() -> [DateComponents]
    
    func requestAccessToCalendar()
    
    func selectedDate(date: Date)
    
    func deleteDatesToUpdate()
    
    func eventOnCalendar(date: DateComponents) -> UICalendarView.Decoration?
    
    func refreshDecorations()
}

final class MonthViewModel: MonthViewModelProtocol {
    
    private let dateBase = DateBase.shared
    
    private(set) var datesToUpdate = Set<DateComponents>() {
        didSet {
            OnChange?()
        }
    }
    
    var eventStore = EKEventStore()
    
    var OnChange: (()->Void)?
    
    init() {
        dateBase.delegate = self
    }
    
    func requestAccessToCalendar() {
        
        let complitionHandler: EKEventStoreRequestAccessCompletionHandler = {
            [weak self] granted, error in
            // почему то complition handler не запускаеться на главном потоке автоматически
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: complitionHandler)
        } else {
            eventStore.requestAccess(to: .event, completion: complitionHandler)
        }
        
    }
    
    private func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc func storeChanged(_ notification: Notification) {
        OnChange?()
    }
    
    func refreshDecorations() {
        OnChange?()
    }
    
    func getDatesToUpdate() -> [DateComponents] {
        dateBase.getDatesToUpdate()
    }
    
    func selectedDate(date: Date) {
        dateBase.selectedDate(date: date)
    }
    
    func deleteDatesToUpdate() {
        dateBase.deleteDatesToUpdate()
    }
    
    func eventOnCalendar(date: DateComponents) -> UICalendarView.Decoration? {
        dateBase.eventOnCalendar(date: date)
    }
}

extension MonthViewModel: DateBaseDelegate {
    func dateBaseUpdate(datesToUpdate: Set<DateComponents>) {
        print("resiv dates from base")
        self.datesToUpdate = datesToUpdate
    }
}

