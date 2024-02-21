//
//  DateExtension.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.09.21.
//

import Foundation

extension Date {
    var shortDay: String {
        DateFormatter.shortDay.string(from: self)
    }
    var shortDayNumeric: String {
        DateFormatter.shortDayNumeric.string(from: self)
    }
    var dayAndDate: String {
        DateFormatter.weekdayAndDate.string(from: self)
    }
    var dayAndMonth: String {
        DateFormatter.dayAndMonth.string(from: self)
    }
    var day: String {
        DateFormatter.onlyDay.string(from: self)
    }
    var time: String {
        DateFormatter.onlyTime.string(from: self)
    }
    var detailedTime: String {
        DateFormatter.detailedTime.string(from: self)
    }
    var numericYear: String {
        DateFormatter.numericYear.string(from: self)
    }
    var numericMonth: String {
        DateFormatter.numericMonth.string(from: self)
    }
    var numericDay: String {
        DateFormatter.numericDay.string(from: self)
    }
    var hour: String {
        DateFormatter.onlyHour.string(from: self)
    }
    var minute: String {
        DateFormatter.onlyMinute.string(from: self)
    }
    var shortDate: String {
        DateFormatter.onlyDate.string(from: self)
    }
    var age: Int {
        let ageComponents = Calendar.current.dateComponents([.year], from: self, to: Date())
        guard let age = ageComponents.year else {
            return -1
        }
        return age
    }
    var dayBefore: Date {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: noon) else {
            return Date()
        }
        return yesterday
    }
    var dayAfter: Date {
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: noon) else {
            return Date()
        }
        return tomorrow
    }
    var noon: Date {
        guard let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) else {
            return Date()
        }
        return noon
    }
    
    var nextHour: Date {
        let date = (Int(DateFormatter.onlyHour.string(from: self)) ?? 12) > 22 ? self.dayAfter : self
        let hour = (Int(DateFormatter.onlyHour.string(from: self)) ?? 12) > 22 ? -1 : (Int(DateFormatter.onlyHour.string(from: self)) ?? 12)
        guard let result = Calendar.current.date(bySettingHour: hour + 1, minute: 0, second: 0, of: date) else {
            return Date()
        }
        return result
    }
    
    var afterNextHour: Date {
        let date = (Int(DateFormatter.onlyHour.string(from: self)) ?? 12) > 22 ? self.dayAfter : self
        let hour = (Int(DateFormatter.onlyHour.string(from: self)) ?? 12) > 22 ? -1 : (Int(DateFormatter.onlyHour.string(from: self)) ?? 12)
        guard let result = Calendar.current.date(bySettingHour: hour + 2, minute: 0, second: 0, of: date) else {
            return Date()
        }
        return result
    }
    
    var hourBefore: Date {
        let date = (Int(DateFormatter.onlyHour.string(from: self)) ?? 12) == 0 ? self.dayBefore : self
        let hour = (Int(DateFormatter.onlyHour.string(from: self)) ?? 12) == 0 ? 24 : (Int(DateFormatter.onlyHour.string(from: self)) ?? 12)
        guard let result = Calendar.current.date(bySettingHour: hour - 1, minute: 0, second: 0, of: date) else {
            return Date()
        }
        return result
    }
    
    init(dateString: String?) {
        guard let dateString = dateString else {
            self = Date()
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: dateString) else {
            self = Date()
            return
        }
        self = date
    }
    
    func daysBefore(amount: Int) -> Date {
        guard let thatDay = Calendar.current.date(byAdding: .day, value: -amount, to: noon) else {
            return Date()
        }
        return thatDay
    }
    
    func daysAfter(amount: Int) -> Date {
        guard let thatDay = Calendar.current.date(byAdding: .day, value: amount, to: noon) else {
            return Date()
        }
        return thatDay
    }
    
    func isOnDifferentDay(than other: Date) -> Bool {
        self.shortDate != other.shortDate
    }
    
    func setHour(hour: Int) -> Date {
        guard let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: self) else {
            return Date()
        }
        return date
    }
}
