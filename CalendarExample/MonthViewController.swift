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
        calendarView.overrideUserInterfaceStyle = .light
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccessToCalendar()
        calendarView.delegate = self
        view.backgroundColor = .white
        subscribeToNotifications()
        setupUI()
        
    }
    
    func requestAccessToCalendar() {
        let complitionHandler: EKEventStoreRequestAccessCompletionHandler = {
            [weak self] granted, error in
            // почему то complition handler не запускаеться на главном потоке автоматически
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                //self.reloadInputViews()
                self.subscribeToNotifications()
            
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: complitionHandler)
        } else {
            eventStore.requestAccess(to: .event, completion: complitionHandler)
        }
    }
    
    func initializeStore() {
        eventStore = EKEventStore()
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }
    
    @objc func storeChanged(_ notification: Notification) {
        calendarView.reloadDecorations(forDateComponents: dateBase.getDatesToUpdate(), animated: true)
    }
    
    @objc func refreshDecorations() {
        calendarView.reloadDecorations(forDateComponents: dateBase.getDatesToUpdate(), animated: true)
    }
}

//MARK: - UI config

private extension MonthViewController {
    
    func setupUI() {
        view.addSubview(calendarView)
        addConstraints()
        
        let updateButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDecorations))
        navigationItem.rightBarButtonItem = updateButton
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250)
        ])
    }
    
    func dateIsSelected(withDate date: Date) {
        let nextController = DetailedDayViewController()
        let navigationController = UINavigationController(rootViewController: nextController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        
        let navigationBar = navigationController.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        dateBase.selectedDate(date: date)
        navigationController.modalPresentationStyle = .fullScreen
        dateBase.deleteDatesToUpdate()
        present(navigationController, animated: true)
    }
}

//MARK: - UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate

extension MonthViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return dateBase.eventOnCalendar(date: dateComponents)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else { return assertionFailure("failed to get dateComponents") }
        guard let date = Calendar.autoupdatingCurrent.date(from: dateComponents) else { return assertionFailure("failed to get date from dateComponents") }
        dateIsSelected(withDate: date)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        selection.selectedDate = nil
        return true
    }
    
}


