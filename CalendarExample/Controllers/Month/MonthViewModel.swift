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

//MARK: - DateBaseDelegate

extension MonthViewModel: DateBaseDelegate {
    func dateBaseUpdate(datesToUpdate: Set<DateComponents>) {
        self.datesToUpdate = datesToUpdate
    }
}

