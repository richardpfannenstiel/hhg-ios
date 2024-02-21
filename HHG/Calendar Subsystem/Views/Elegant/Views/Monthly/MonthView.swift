// Kevin Li - 10:53 PM - 6/6/20

import SwiftUI

struct MonthView: View, MonthlyCalendarManagerDirectAccess {

    @Environment(\.calendarTheme) var theme: CalendarTheme

    @ObservedObject var calendarManager: MonthlyCalendarManager
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets

    let month: Date

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return calendar.generateDates(
            inside: monthInterval,
            matching: calendar.firstDayOfEveryWeek)
    }

    private var isWithinSameMonthAndYearAsToday: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularities: [.month, .year])
    }

    var body: some View {
        VStack {
            if !calendarManager.showingList {
                VStack {
                    HStack {
                        monthYearHeader
                        Spacer()
                        scrollBackButton
                        addEntryButton
                    }.padding(.horizontal)
                    weeksViewWithDaysOfWeekHeader
                        .padding(.top)
                        .padding(.bottom, 20)
                }
            }
            
            if selectedDate != nil {
                selectedDayEntries
            } else {
                noCalendarEntries
            }
            Spacer()
        }.padding(.top,edges!.top)
        .frame(width: CalendarConstants.Monthly.cellWidth, height: CalendarConstants.cellHeight)
    }
    
    private var scrollBackButton: some View {
        Button(action: { calendarManager.scrollBackToToday() }, label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.HHG_Blue)
                .overlay(
                    Image(systemName: "arrow.uturn.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                )
        }).buttonStyle(PlainButtonStyle())
    }
    
    private var addEntryButton: some View {
        Button(action: calendarManager.add, label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.HHG_Blue)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                )
        }).buttonStyle(PlainButtonStyle())
    }
    
    private var selectedDayEntries: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
            calenderAccessoryView
                .padding(.top)
                .padding(.horizontal)
                .id(selectedDate!)
        }.cornerRadius(25)
    }
    
    private var noCalendarEntries: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
            Text("No day selected".localized)
                .padding(.top)
                .padding(.horizontal)
        }.cornerRadius(25)
    }

}

private extension MonthView {

    var monthYearHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                monthText
                //yearText
            }
            Spacer()
        }
    }

    var monthText: some View {
        Text(month.fullMonth)
            .font(Font.system(size: 30, weight: .semibold, design: .rounded))
            .kerning(0.25)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? theme.primary : .primary)
        /*Text(month.fullMonth.uppercased())
            .font(.system(size: 26))
            .bold()
            .tracking(7)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? theme.primary : .primary)*/
    }

    var yearText: some View {
        Text(month.year)
            .font(.body)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? theme.primary : .gray)
            .opacity(0.95)
        /*Text(month.year)
            .font(.system(size: 12))
            .tracking(2)
            .foregroundColor(isWithinSameMonthAndYearAsToday ? theme.primary : .gray)
            .opacity(0.95)*/
    }

}

private extension MonthView {

    var weeksViewWithDaysOfWeekHeader: some View {
        VStack(spacing: 32) {
            daysOfWeekHeader
            weeksViewStack
        }
    }

    var daysOfWeekHeader: some View {
        HStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(calendar.dayOfWeekInitials, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(.caption)
                    .frame(width: CalendarConstants.Monthly.dayWidth)
                    .foregroundColor(.gray)
            }
        }
    }

    var weeksViewStack: some View {
        VStack(spacing: CalendarConstants.Monthly.gridSpacing) {
            ForEach(weeks, id: \.self) { week in
                WeekView(calendarManager: self.calendarManager, week: week)
            }
        }
    }

}

private extension MonthView {

    var calenderAccessoryView: some View {
        CalendarAccessoryView(calendarManager: calendarManager)
    }

}

private struct CalendarAccessoryView: View, MonthlyCalendarManagerDirectAccess {

    @ObservedObject var calendarManager: MonthlyCalendarManager

    @State private var isVisible = false

    private var numberOfDaysFromTodayToSelectedDate: Int {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfSelectedDate = calendar.startOfDay(for: selectedDate!)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfSelectedDate).day!
    }

    private var isNotYesterdayTodayOrTomorrow: Bool {
        abs(numberOfDaysFromTodayToSelectedDate) > 1
    }
    
    private var isNotToday: Bool {
        abs(numberOfDaysFromTodayToSelectedDate) > 0
    }

    var body: some View {
        VStack {
            selectedDayInformationView
            GeometryReader { geometry in
                self.datasource?.calendar(viewForSelectedDate: self.selectedDate!,
                                          dimensions: geometry.size)
            }
        }
        .onAppear(perform: makeVisible)
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.5))
    }

    private func makeVisible() {
        isVisible = true
    }

    private var selectedDayInformationView: some View {
        HStack {
            if !calendarManager.showingList {
                VStack(alignment: .leading) {
                    dayOfWeekWithMonthAndDayText
                    if isNotYesterdayTodayOrTomorrow {
                        daysFromTodayText
                    }
                }
            }
            
            Spacer()
            //showListView
        }.padding(.bottom, 5)
    }
    
    private var showListView: some View {
        Button(action: calendarManager.toggleList) {
            HStack {
                Image(systemName: calendarManager.showingList ? "chevron.down.circle" : "chevron.up.circle")
                Text(calendarManager.showingList ? "Dismiss".localized : "Show List".localized)
            }.padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .background(Color.HHG_Blue)
            .cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }

    private var dayOfWeekWithMonthAndDayText: some View {
        let monthDayText: String
        if numberOfDaysFromTodayToSelectedDate == -1 {
            monthDayText = "Yesterday".localized
        } else if numberOfDaysFromTodayToSelectedDate == 0 {
            monthDayText = "Today".localized
        } else if numberOfDaysFromTodayToSelectedDate == 1 {
            monthDayText = "Tomorrow".localized
        } else {
            monthDayText = selectedDate!.dayAndDate
        }

        return Text(monthDayText.uppercased())
            .font(.subheadline)
            .bold()
    }

    private var daysFromTodayText: some View {
        let isBeforeToday = numberOfDaysFromTodayToSelectedDate < 0

        return Text("\(abs(numberOfDaysFromTodayToSelectedDate)) \(isBeforeToday ? "days ago".localized : "days from today".localized)")
            .font(.caption)
            .foregroundColor(.secondary)
        /*return Text("\(abs(numberOfDaysFromTodayToSelectedDate)) \(daysDescription)")
            .font(.system(size: 10))
            .foregroundColor(.gray)*/
    }

}
