//
//  MonthViewController.swift
//  CalendarExample
//
//  Created by admin on 22.01.2024.
//

import UIKit
import EventKit
import EventKitUI


final class MonthViewController: UIViewController {
    
    private let dateBase = DateBase.shared
    private var eventStore = EKEventStore()
    
    private lazy var calendarView = {
        let calendarView = UICalendarView()
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.calendar = .current
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        view.backgroundColor = .white
        
        setupUI()
    }
}

//MARK: - UI config

private extension MonthViewController {
    
    func setupUI() {
        view.addSubview(calendarView)
        addConstraints()
    }
    
    func addConstraints() {
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        
    }
    
    func dateIsSelected() {
        let nextController = DetailedDayViewController()
        present(nextController, animated: true)
    }
    
    
}

//MARK: - UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate

extension MonthViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return dateBase.eventOnCalendar(date: dateComponents)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        dateIsSelected()
    }
}

