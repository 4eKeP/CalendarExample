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
    func detailedDayViewController()
}

final class DetailedDayViewController: DayViewController {
    
    private var datesToUpdate = Set<DateComponents>()
    
    private let calendarTitle = Constants.DetailedDayConstants.calendarTitle
    
    private var viewModel: DetailDayViewModelProtocol
    
    
    init(viewModel: DetailDayViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        subscribeToNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        move(to: viewModel.dateBase.getSelectedDate())
    }
    
    @objc func cancelButtonPressed() {
        viewModel.cancelButtonPress()
        dismiss(animated: true)
    }
    
    
    //MARK: - DayViewDataSource

        
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        viewModel.eventsForDate(date, calendar: calendar)
    }
        
    //MARK: - DayViewDelegate
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        viewModel.addDateToUpdate(date: date)
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        endEventEditing()
        viewModel.addDateToUpdate(date: date)
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
                try! viewModel.dateBase.eventStore.save(editingEvent.event, span: .thisEvent)
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
        eventController.delegate = self
        viewModel.addDateToUpdate(date: ekEvent.startDate)
        navigationController?.pushViewController(eventController, animated: true)
    }
    
    //MARK: - Event editing

    
    private func createNewEvent(at date: Date) -> EventStoreWrapper {
        viewModel.createNewEvent(at: date, calendar: calendar)
    }
    
    
    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = viewModel.dateBase.eventStore
        eventEditViewController.editViewDelegate = self
        
        present(eventEditViewController, animated: true)
    }
    
}

//MARK: - Access request to Events

private extension DetailedDayViewController {
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: viewModel.dateBase.eventStore)
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

extension DetailedDayViewController: EKEventViewDelegate {
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        endEventEditing()
        reloadData()
        dismiss(animated: true)
        viewModel.cancelButtonPress()
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

