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
        
        static let errorTitleEvents: String = "Что-то пошло не так"
        
        static let errorMessageEvents: String = "Без полного доступа к событиям календаря функции приложения недоступны, для включения перейдите Настойки-> Конфиденциальность и безопастность-> Календари"
        
        static let errorTitleNotifications: String = "Что-то пошло не так"
        
        static let errorMessageNotifications: String = "Без доступа к уведомлениям функции приложения недоступны, для включения перейдите Настойки-> Конфиденциальность и безопастность"
        
        static let errorButtonTitle: String = "Ок"
    }
    
    enum OnBoardingConstants {
        static let spacing: CGFloat = 20
        
        static let buttonHeight: CGFloat = 60
        
        static let centerOffset: CGFloat = 150
        
        static let bottomSpacing: CGFloat = 86
        
        static let buttonTitle: String = "Понятно!"
        
        static let controller1Title: String = "Нажми на дату что бы узнать подробности"
        
        static let controller2Title: String = "Зажми на поле что бы добавить новое событие или нажми для просмотра события"
        
        static let controller3Title: String = "Что бы Удалить нажми на Удолить событие, для редактирования на Править"
        
        static let page1Image = UIImage(named: "OnBoarding1")
        
        static let page2Image = UIImage(named: "OnBoarding2")
        
        static let page3Image = UIImage(named: "OnBoarding3")
    }
    
    enum DetailedDayConstants {
        static let calendarTitle = "Календарь"
    }
}
