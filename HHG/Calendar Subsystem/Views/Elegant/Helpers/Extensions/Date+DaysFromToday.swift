// Kevin Li - 1:54 PM - 6/13/20

import Foundation

extension Date {

    static func daysFromToday(_ days: Int) -> Date {
        Date().addingTimeInterval(TimeInterval(60*60*24*days))
    }
    
    var firstDayOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        let startOfMonth = Calendar.current.date(from: components) ?? Date()
        return startOfMonth
    }

}

