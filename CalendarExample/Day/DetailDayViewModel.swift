//
//  DetailDayViewModel.swift
//  CalendarExample
//
//  Created by admin on 01.02.2024.
//

import Foundation

protocol DetailDayViewModelProtocol {
    var delegate: DetailedDayViewControllerDelegate? { get set }
    
    func cancelButtonPress()
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    weak var delegate: DetailedDayViewControllerDelegate?
    
    func cancelButtonPress() {
        delegate?.detailedDayViewController()
    }
}
