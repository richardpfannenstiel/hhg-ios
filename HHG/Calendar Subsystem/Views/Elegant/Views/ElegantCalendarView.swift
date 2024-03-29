// Kevin Li - 6:19 PM - 6/6/20

import ElegantPages
import SwiftUI

public struct ElegantCalendarView: View {

    var theme: CalendarTheme = .default
    public var axis: Axis = .horizontal

    @ObservedObject var calendarManager: ElegantCalendarManager

    public var body: some View {
        content
    }
    
    private var content: some View {
        Group {
            if axis == .vertical {
                ElegantVPages(manager: calendarManager.pagesManager) {
                    yearlyCalendarView
                    monthlyCalendarView
                }
                .onPageChanged(calendarManager.scrollToYearIfOnYearlyView)
                .erased
            } else {
                ElegantHPages(manager: calendarManager.pagesManager) {
                    yearlyCalendarView
                    monthlyCalendarView
                }
                .onPageChanged(calendarManager.scrollToYearIfOnYearlyView)
                .erased
            }
        }
    }

    private var yearlyCalendarView: some View {
        YearlyCalendarView(calendarManager: calendarManager.yearlyManager)
            .axis(axis.inverted)
            .theme(theme)
    }

    private var monthlyCalendarView: some View {
        MonthlyCalendarView(calendarManager: calendarManager.monthlyManager)
            .axis(axis.inverted)
            .theme(theme)
    }

}
