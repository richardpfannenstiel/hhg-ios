// Kevin Li - 5:20 PM - 6/14/20

import Combine
import ElegantPages
import SwiftUI

public class MonthlyCalendarManager: ObservableObject, ConfigurationDirectAccess {

    @Published public private(set) var currentMonth: Date
    @Published public var selectedDate: Date? = nil
    @Published public var showingList: Bool = false
    @Published public var showingAddView: Bool = false
    @Published public var showingLoading: Bool = false

    @Published var listManager: ElegantListManager

    @Published public var datasource: MonthlyCalendarDataSource?
    @Published public var delegate: MonthlyCalendarDelegate?

    @Published var communicator: ElegantCalendarCommunicator?

    @Published var configuration: CalendarConfiguration
    @Published var months: [Date]
    
    @Published var navigationStore = AppNavigationStore.shared

    var allowsHaptics: Bool = true
    private var isHapticActive: Bool = true

//    private var anyCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []

    public init(configuration: CalendarConfiguration, initialMonth: Date? = nil) {
        self.configuration = configuration

        let months = configuration.calendar.generateDates(
            inside: DateInterval(start: configuration.startDate,
                                 end: configuration.calendar.endOfDay(for: configuration.endDate)),
            matching: .firstDayOfEveryMonth)

        self.months = configuration.ascending ? months : months.reversed()

        var startingPage: Int = 0
        if let initialMonth = initialMonth {
            startingPage = configuration.calendar.monthsBetween(configuration.referenceDate, and: initialMonth)
        }

        selectedDate = Date()
        currentMonth = months[startingPage]

        listManager = .init(startingPage: startingPage,
                             pageCount: months.count)
        
        CalendarStore.shared.setCurrentMonth(month: currentMonth.fullMonth)
        
        assign()

        $delegate.sink { [self] in
            $0?.calendar(willDisplayMonth: self.currentMonth)
            configureInitMonth()
        }.store(in: &cancellables)
    }

}

extension MonthlyCalendarManager {
    
    func assign() {
        navigationStore.$showingAddCalendarEvent
            .assign(to: \.showingAddView, on: self)
            .store(in: &cancellables)
    }
    
    func toggleList() {
        withAnimation(Animation.easeInOut(duration: 0.9)) {
            showingList.toggle()
            if !showingLoading {
                toggleLoading()
            }
            TabBarStore.shared.setBar(bool: !showingList)
        }
    }
    
    func add() {
        showingAddView = true
    }
    
    func toggleLoading() {
        withAnimation(Animation.easeInOut(duration: 0.9)) {
            showingLoading.toggle()
        }
    }
}

extension MonthlyCalendarManager {

    func configureNewMonth(at page: Int) {
        if months[page] != currentMonth {
            currentMonth = months[page]
            
            if currentMonth.fullMonth == Date().fullMonth {
                selectedDate = Date()
            } else {
                selectedDate = currentMonth.firstDayOfMonth
            }

            delegate?.calendar(willDisplayMonth: currentMonth)
            CalendarStore.shared.setCurrentMonth(month: currentMonth.fullMonth)

            if allowsHaptics && isHapticActive {
                UIImpactFeedbackGenerator.generateSelectionHaptic()
            } else {
                isHapticActive = true
            }
        }
    }
    
    func configureInitMonth() {
        currentMonth = months[0]
        if currentMonth.fullMonth == Date().fullMonth {
            selectedDate = Date()
        } else {
            selectedDate = currentMonth.firstDayOfMonth
        }
    }
    
    func eventAddedRefresh(newDate: Date) {
        let page = calendar.monthsBetween(referenceDate, and: newDate)
        currentMonth = months[page]
        scrollToDay(newDate)
    }
}

extension MonthlyCalendarManager {

    @discardableResult
    public func scrollBackToToday() -> Bool {
        scrollToDay(Date())
    }

    @discardableResult
    public func scrollToDay(_ day: Date, animated: Bool = true) -> Bool {
        let didScrollToMonth = scrollToMonth(day, animated: animated)
        let canSelectDay = datasource?.calendar(canSelectDate: day) ?? true

        if canSelectDay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.dayTapped(day: day, withHaptic: !didScrollToMonth)
            }
        }

        return canSelectDay
    }

    func dayTapped(day: Date, withHaptic: Bool) {
        if allowsHaptics && withHaptic {
            UIImpactFeedbackGenerator.generateSelectionHaptic()
        }

        selectedDate = day
        delegate?.calendar(didSelectDay: day)
    }

    @discardableResult
    public func scrollToMonth(_ month: Date, animated: Bool = true) -> Bool {
        isHapticActive = animated

        let needsToScroll = !calendar.isDate(currentMonth, equalTo: month, toGranularities: [.month, .year])

        if needsToScroll {
            let page = calendar.monthsBetween(referenceDate, and: month)
            listManager.scroll(to: page, animated: animated)
        } else {
            isHapticActive = true
        }

        return needsToScroll
    }

}

extension MonthlyCalendarManager {

    static let mock = MonthlyCalendarManager(configuration: .mock)
    static let mockWithInitialMonth = MonthlyCalendarManager(configuration: .mock, initialMonth: .daysFromToday(60))

}

protocol MonthlyCalendarManagerDirectAccess: ConfigurationDirectAccess {

    var calendarManager: MonthlyCalendarManager { get }
    var configuration: CalendarConfiguration { get }

}

extension MonthlyCalendarManagerDirectAccess {

    var configuration: CalendarConfiguration {
        calendarManager.configuration
    }

    var listManager: ElegantListManager {
        calendarManager.listManager
    }

    var months: [Date] {
        calendarManager.months
    }

    var communicator: ElegantCalendarCommunicator? {
        calendarManager.communicator
    }

    var datasource: MonthlyCalendarDataSource? {
        calendarManager.datasource
    }

    var delegate: MonthlyCalendarDelegate? {
        calendarManager.delegate
    }

    var currentMonth: Date {
        calendarManager.currentMonth
    }

    var selectedDate: Date? {
        calendarManager.selectedDate
    }

    func configureNewMonth(at page: Int) {
        calendarManager.configureNewMonth(at: page)
    }

    func scrollBackToToday() {
        calendarManager.scrollBackToToday()
    }

}

private extension Calendar {

    func monthsBetween(_ date1: Date, and date2: Date) -> Int {
        let startOfMonthForDate1 = startOfMonth(for: date1)
        let startOfMonthForDate2 = startOfMonth(for: date2)
        return abs(dateComponents([.month],
                              from: startOfMonthForDate1,
                              to: startOfMonthForDate2).month!)
    }

}
