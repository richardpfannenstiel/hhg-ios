// Kevin Li - 10:54 PM - 6/6/20

import SwiftUI

struct WeekView: View, MonthlyCalendarManagerDirectAccess {

    @ObservedObject var calendarManager: MonthlyCalendarManager

    let week: Date

    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        return calendar.generateDates(
            inside: weekInterval,
            matching: .everyDay)
    }

    var body: some View {
        HStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(days, id: \.self) { day in
                DayView(calendarManager: self.calendarManager, week: self.week, day: day)
            }
        }
    }

}
