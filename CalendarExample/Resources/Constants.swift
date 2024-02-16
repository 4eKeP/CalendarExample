//
//  Constants.swift
//  CalendarExample
//
//  Created by admin on 06.02.2024.
//

import UIKit

enum Constants {
    
    enum ForkPageConstants {
       static let logoImage = UIImage(systemName: "calendar")
        
        static let logoSide: CGFloat = 100
        
        static let errorTitleEvents: String = NSLocalizedString("errorTitle", comment: "message header when there is no access to data")
        
        static let errorMessageEvents: String = NSLocalizedString("errorMessageEvents", comment: "assistant message when there is no access to event data")
        
        static let errorTitleNotifications: String = NSLocalizedString("errorTitle", comment: "message header when there is no access to data")
        
        static let errorMessageNotifications: String = NSLocalizedString("errorMessageNotifications", comment: "Helper message when there is no access to notifications")
        
        static let errorButtonTitle: String = NSLocalizedString("errorButtonTitle", comment: "")
    }
    
    enum OnBoardingConstants {
        static let spacing: CGFloat = 20
        
        static let buttonHeight: CGFloat = 60
        
        static let centerOffset: CGFloat = 150
        
        static let bottomSpacing: CGFloat = 86
        
        static let buttonTitle: String = NSLocalizedString("buttonTitle", comment: "agreement to move on after training")
        
        static let controller1Title: String = NSLocalizedString("controller1Title", comment: "message on page 1 of on boarding")
        
        static let controller2Title: String = NSLocalizedString("controller2Title", comment: "message on page 2 of on boarding")
        
        static let controller3Title: String = NSLocalizedString("controller3Title", comment: "message on page 3 of on boarding")
        
        static let page1Image = UIImage(named: "OnBoarding1")
        
        static let page2Image = UIImage(named: "OnBoarding2")
        
        static let page3Image = UIImage(named: "OnBoarding3")
    }
    
    enum DetailedDayConstants {
        static let calendarTitle = NSLocalizedString("calendarTitle", comment: "calendar title on detailed page")
    }
}
