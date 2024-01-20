//
//  EventStoreWrapper.swift
//  CalendarExample
//
//  Created by admin on 20.01.2024.
//

import UIKit
import EventKit
import CalendarKit

final class EventStoreWrapper: EventDescriptor {
    
    private(set) var event: EKEvent
    
    var dateInterval: DateInterval {
        get {
            DateInterval(start: event.startDate, end: event.endDate)
        }
        
        set {
            event.startDate = newValue.start
            event.endDate = newValue.end
        }
    }
    
    var isAllDay: Bool {
        get {
            event.isAllDay
        }
        set {
            event.isAllDay = newValue
        }
    }
    
    var text: String {
        get {
            event.title
        }
        set {
            event.title = newValue
        }
    }
    
    var attributedText: NSAttributedString?
    
    var lineBreakMode: NSLineBreakMode?
    
    var font: UIFont = UIFont.boldSystemFont(ofSize: 12)
    
    var color: UIColor {
        get {
            UIColor(cgColor: event.calendar.cgColor)
        }
    }
    
    var textColor: UIColor = SystemColors.label
    
    var backgroundColor = UIColor()
    
    weak var editedEvent: CalendarKit.EventDescriptor? {
        didSet {
            updateColors()
        }
    }
    //MARK: - Init
    
    init(EKEvent: EKEvent) {
        self.event = EKEvent
        applyStandardColors()
    }
    
    func makeEditable() -> Self {
        let clone = Self(EKEvent: event)
        clone.editedEvent = self
        return clone
    }
    
    func commitEditing() {
        guard let edited = editedEvent else { return }
        edited.dateInterval = dateInterval
    }
}

//MARK: - Private metods
private extension EventStoreWrapper {
    
    private func updateColors() {
      (editedEvent != nil) ? applyEditingColors() : applyStandardColors()
    }
    
    // цвета используемые когда не в режиме редактирования
    private func applyStandardColors() {
      backgroundColor = dynamicStandardBackgroundColor()
      textColor = dynamicStandardTextColor()
    }
    
    // цвета используемые в режиме редактирования
    private func applyEditingColors() {
      backgroundColor = color.withAlphaComponent(0.95)
      textColor = .white
    }
    
    //динамически изменяющиеся цвета в зависимости от стиля изображения (dark / light)
    private func dynamicStandardBackgroundColor() -> UIColor {
      let light = backgroundColorForLightTheme(baseColor: color)
      let dark = backgroundColorForDarkTheme(baseColor: color)
      return dynamicColor(light: light, dark: dark)
    }
    
    //динамически изменяющиеся цвета в зависимости от стиля изображения (dark / light)
    private func dynamicStandardTextColor() -> UIColor {
      let light = textColorForLightTheme(baseColor: color)
      return dynamicColor(light: light, dark: color)
    }
    
    private func textColorForLightTheme(baseColor: UIColor) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a)
    }
    
    private func backgroundColorForLightTheme(baseColor: UIColor) -> UIColor {
      baseColor.withAlphaComponent(0.3)
    }
    
    private func backgroundColorForDarkTheme(baseColor: UIColor) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a * 0.8)
    }
    
    private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
      if #available(iOS 13.0, *) {
        return UIColor { traitCollection in
          let interfaceStyle = traitCollection.userInterfaceStyle
          switch interfaceStyle {
          case .dark:
            return dark
          default:
            return light
          }
        }
      } else {
        return light
      }
    }
}
