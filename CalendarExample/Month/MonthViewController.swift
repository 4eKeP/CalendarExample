//
//  MonthViewController.swift
//  CalendarExample
//
//  Created by admin on 22.01.2024.
//

import UIKit

import EventKitUI


final class MonthViewController: UIViewController {
    
    private var viewModel: MonthViewModelProtocol
    
    private lazy var calendarView = {
        let calendarView = UICalendarView()
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.calendar = .current
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.locale = .autoupdatingCurrent
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    init(viewModel: MonthViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestAccessToCalendar()
        calendarView.delegate = self
        view.backgroundColor = .clear
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        switch view.window?.windowScene?.screen.traitCollection.userInterfaceStyle {
                case .light:
                    calendarView.overrideUserInterfaceStyle = .light
                    view.backgroundColor = .white
                case .dark:
                    calendarView.overrideUserInterfaceStyle = .dark
                    view.backgroundColor = .black
                case .unspecified:
                    calendarView.overrideUserInterfaceStyle = .light
                    view.backgroundColor = .white
                case .none:
                    calendarView.overrideUserInterfaceStyle = .light
                    view.backgroundColor = .white
                @unknown default:
                    assertionFailure("Неизвесный стиль интерфейса")
                }
    }
    
    func updateDecorations() {
        calendarView.reloadDecorations(forDateComponents: viewModel.getDatesToUpdate(), animated: true)
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
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250)
        ])
    }
    
    func dateIsSelected(withDate date: Date) {
        let viewModel = DetailDayViewModel()
        let nextController = DetailedDayViewController(viewModel: viewModel)
        viewModel.delegate = self
        let navigationController = UINavigationController(rootViewController: nextController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        
        let navigationBar = navigationController.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        self.viewModel.selectedDate(date: date)
        navigationController.modalPresentationStyle = .fullScreen
        self.viewModel.deleteDatesToUpdate()
        present(navigationController, animated: true)
    }
}

//MARK: - UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate

extension MonthViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return viewModel.eventOnCalendar(date: dateComponents)
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

extension MonthViewController: DetailedDayViewControllerDelegate {
    func detailedDayViewController() {
        updateDecorations()
    }
}


