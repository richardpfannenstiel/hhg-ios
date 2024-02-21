//
//  CalendarElegantViewModel.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 01.10.21.
//

import Foundation
import Combine
import SwiftUI

final class CalendarElegantViewModel: ObservableObject {
    
    @Published var selectedUpcomingEvent: CalendarEvent?
    @Published var showingDetail: Bool = false
    
    @Published var showingTabBar = false
    @Published var frame: CGRect = .zero
    @Published var readers: [Int : GeometryProxy] = [ : ]
    
    @Published var showingAlert = false
    @Published var showingSubtileAlert = false
    @Published var alertTitle = ""
    @Published var alertSubtitle = ""
    @Published var alertImage = Image(systemName: "checkmark.circle.fill")
    @Published var alertBoxes: [CustomAlertBox] = []
    
    @Published var navigationStore = AppNavigationStore.shared
    
    // MARK: Stored Properties
    
    @Published var calendarManager: MonthlyCalendarManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    // MARK: Initialization
    
    init() {
        calendarManager = MonthlyCalendarManager(
            configuration: CalendarConfiguration(startDate: Date().addingTimeInterval(TimeInterval(-60 * 60 * 24 * 30 * 12)),
                                                 endDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * 30 * 12))),
            initialMonth: Date())
        calendarManager.datasource = self
        
        assign()
    }
    
    private func assign() {
        navigationStore.$calendarEvent
            .assign(to: \.selectedUpcomingEvent, on: self)
            .store(in: &cancellables)
        navigationStore.$showingCalendarEventDetails
            .assign(to: \.showingDetail, on: self)
            .store(in: &cancellables)
        
        navigationStore.$showingInvalidCalendarEvent
            .assign(to: \.showingAlert, on: self)
            .store(in: &cancellables)
        navigationStore.$alertTitle
            .assign(to: \.alertTitle, on: self)
            .store(in: &cancellables)
        navigationStore.$alertSubtitle
            .assign(to: \.alertSubtitle, on: self)
            .store(in: &cancellables)
        navigationStore.$alertBoxes
            .assign(to: \.alertBoxes, on: self)
            .store(in: &cancellables)
    }
    
    func showCalendarDetailView(event: CalendarEvent) {
        if !CalendarStore.shared.events.contains(where: { $0.id == event.id }) {
            showDeletedEventSelectionAlert()
            return
        }
        selectedUpcomingEvent = event
        withAnimation {
            showingDetail = true
            TabBarStore.shared.setBar(bool: false)
        }
    }
    
    func showTabBar() {
        if !calendarManager.showingList {
            withAnimation {
                TabBarStore.shared.setBar(bool: true)
            }
        }
    }
    
    func showDeletedEventSelectionAlert() {
        alertTitle = "Error".localized
        alertSubtitle = "Not Available".localized
        alertImage = Image(systemName: "xmark.circle")
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showingSubtileAlert.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) { [self] in
            if showingSubtileAlert {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showingSubtileAlert = false
                }
            }
        }
    }
}

extension CalendarElegantViewModel: MonthlyCalendarDataSource {
    
    var prefixEvents: [CalendarEvent] {
        return TabBarStore.shared.selectedTab == "calendar" ? (CalendarStore.shared.currentMonthEvents) : []
    }
    
    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        return 0.2 * Double(prefixEvents.filter({ $0.startDate.shortDate == date.shortDate }).count)
    }

    func calendar(canSelectDate date: Date) -> Bool {
        return true
    }
    
    private func lazyScrollView(date: Date) -> some View {
        ZStack {
            SwiftUI.ScrollView {
                ScrollViewReader { value in
                    LazyVStack {
                        ForEach(CalendarStore.shared.events/*.filter({ $0.id != selectedUpcomingEvent?.id })*/) { event in
                            Button(action: { self.showCalendarDetailView(event: event) }, label: {
                                SmallCalendarCardView(event: event, animation: nil)
                                    .id(event.id)
                            }).buttonStyle(ScaleButtonStyle())
                        }
                    }.onAppear {
                        if let id = CalendarStore.shared.events.first(where: { $0.startDate.shortDate == date.shortDate })?.id {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    value.scrollTo(id, anchor: .top)
                                    self.calendarManager.toggleLoading()
                                }
                            }
                        } else {
                            let id = CalendarStore.shared.events.first(where: { $0.startDate.shortDate >= date.shortDate })!.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    value.scrollTo(id, anchor: .top)
                                    self.calendarManager.toggleLoading()
                                }
                            }
                        }
                        
                    }
                }
            }
            if calendarManager.showingLoading {
                loadingView
            }
        }
        
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .frame(width: 60, height: 50)
                Text("Loading".localized)
                Spacer()
            }.foregroundColor(.secondary)
            Spacer()
        }
        .frame(width: screen.width / 2, height: screen.height / 4)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        AnyView(Group {
            if prefixEvents.filter({ $0.startDate.shortDate == date.shortDate }).isEmpty {
                if calendarManager.showingList {
                    lazyScrollView(date: date)
                } else {
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "calendar.badge.minus")
                                .resizable()
                                .frame(width: 60, height: 50)
                            Text("No entries".localized)
                            Spacer()
                        }.foregroundColor(.secondary)
                        Spacer()
                    }.padding(.bottom, 80)
                }
            } else {
                if calendarManager.showingList {
                    lazyScrollView(date: date)
                } else {
//                    SwiftUI.ScrollView {
//                        LazyVStack {
//                            ForEach(prefixEvents.filter({ $0.startDate.shortDate == date.shortDate })) { [self] event in
//                                Button(action: { showCalendarDetailView(event: event) }, label: {
//                                    SmallCalendarCardView(event: event, animation: nil)
//                                        .overlay(
//                                            GeometryReader { reader in
//                                                Text("")
//                                                    .onAppear {
//                                                        readers[event.id] = reader
//                                                    }
//                                            }
//                                        )
//                                }).buttonStyle(ScaleButtonStyle())
//                                .id(event.id)
//                            }
//                        }
//                    }
                    SwiftUI.ScrollView {
                        ScrollViewReader { value in
                            VStack {
                                ForEach(self.prefixEvents.filter({ $0.startDate.shortDate == date.shortDate })) { event in
                                    Button(action: { self.showCalendarDetailView(event: event) }, label: {
                                        SmallCalendarCardView(event: event, animation: nil)
                                    }).buttonStyle(ScaleButtonStyle())
                                }
                            }.padding(.bottom, 80)
                        }
                    }
                }
            }
        })
    }
}
