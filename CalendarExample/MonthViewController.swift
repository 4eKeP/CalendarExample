//
//  MonthViewController.swift
//  CalendarExample
//
//  Created by admin on 22.01.2024.
//

import UIKit



final class MonthViewController: UIViewController {
    
    private lazy var calendarView = {
        let calendarView = UICalendarView()
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
    
    
}

//MARK: - UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate

extension MonthViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
}

