// Kevin Li - 2:26 PM - 6/14/20

import ElegantPages
import SwiftUI

public struct MonthlyCalendarView: View, MonthlyCalendarManagerDirectAccess {

    var theme: CalendarTheme = .default
    public var axis: Axis = .vertical

    @ObservedObject var calendarManager: MonthlyCalendarManager

    private var isTodayWithinDateRange: Bool {
        Date() >= calendar.startOfDay(for: startDate) &&
            calendar.startOfDay(for: Date()) <= endDate
    }

    private var isCurrentMonthYearSameAsTodayMonthYear: Bool {
        calendar.isDate(currentMonth, equalTo: Date(), toGranularities: [.month, .year])
    }

    public var body: some View {
        GeometryReader { geometry in
            self.content(geometry: geometry)
        }.sheet(isPresented: $calendarManager.showingAddView) {
            CalendarEntryAddView(viewModel: CalendarEntryAddViewModel(calendarManager: calendarManager))
        }
    }

    private func content(geometry: GeometryProxy) -> some View {
        CalendarConstants.Monthly.cellWidth = geometry.size.width

        return ZStack(alignment: .top) {
            monthsList
        }
        .frame(height: CalendarConstants.cellHeight)
    }

    private var monthsList: some View {
        ElegantHList(manager: listManager,
                     pageTurnType: .monthlyEarlyCutoff,
                     viewForPage: monthView)
            .onPageChanged(configureNewMonth)
            .frame(width: CalendarConstants.Monthly.cellWidth)
    }

    private func monthView(for page: Int) -> AnyView {
        MonthView(calendarManager: calendarManager, month: months[page])
            .environment(\.calendarTheme, theme)
            .erased
    }

}

private extension PageTurnType {

    static var monthlyEarlyCutoff: PageTurnType = .earlyCutoff(config: .monthlyConfig)

}

public extension EarlyCutOffConfiguration {

    static let monthlyConfig = EarlyCutOffConfiguration(
        scrollResistanceCutOff: UIScreen.main.bounds.width / 2,
        pageTurnCutOff: UIScreen.main.bounds.width / 3,
        pageTurnAnimation: .spring(response: 0.3, dampingFraction: 0.95))

}
