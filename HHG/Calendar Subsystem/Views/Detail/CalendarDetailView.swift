//
//  CalendarDetailView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 04.08.21.
//

import SwiftUI

struct CalendarDetailView: View {
    
    @StateObject var viewModel: CalendarDetailViewModel
    
    @Binding var showing: Bool
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                ZStack {
                    viewModel.event.image
                        .frame(width: screen.width)
                        .cornerRadius(40)
                }.frame(height: 250)
                .offset(y: -30)
                
                HStack {
                    closeButton
                    Spacer()
                    if viewModel.canEdit {
                        editButton
                    }
                }.opacity(viewModel.animationFinished ? 1 : 0)
                .padding(.horizontal)
                .padding(.top,edges!.top)
                
                dateView
                    .offset(y: 180)
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.event.title)
                    .font(Font.system(size: 35, weight: .semibold, design: .rounded))
                    .kerning(0.25)
                creatorView
                HStack {
                    Button(action: viewModel.changeParticipation) {
                        Text(viewModel.sendingParticipatingRequest ? "" : (viewModel.userParticipates ? "Cancel".localized : "Participate".localized))
                            .transaction { transaction in transaction.animation = .easeOut }
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.width - 80, height: 40)
                            .background(Color.HHG_Blue)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .overlay(
                                Group {
                                    if viewModel.sendingParticipatingRequest {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(width: 30, height: 30)
                                            .padding(.vertical)
                                    } else {
                                        Text("")
                                    }
                                }
                            )
                    }.buttonStyle(PlainButtonStyle())
                    .disabled(viewModel.deleted)
                    Button(action: viewModel.showOptions) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.HHG_Blue)
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 20, height: 5)
                                .foregroundColor(.white)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    .disabled(viewModel.deleted)
                }.padding(.vertical, 10)
                Divider()
                if !viewModel.description.isEmpty {
                    descriptionView
                    Divider()
                }
                if !viewModel.participants.isEmpty {
                    CalendarEventParticipantsView(viewModel: CalendarEventParticipationViewModel(eventID: viewModel.event.id, calendarDetailModel: viewModel, showAllParticipants: viewModel.showAllParticipants))
                        .sheet(isPresented: $viewModel.showingAllParticipantsView) {
                            CalendarParticipantsListView(viewModel: CalendarParticipantsListViewModel(participants: viewModel.participants, dismiss: viewModel.dismissAllParticipants))
                        }
                }
            }.opacity(viewModel.animationFinished ? 1 : 0)
            .padding(.horizontal)
            Spacer()
        }.subtileAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, subtitle: viewModel.alertSubtitle, image: viewModel.alertImage, showingClose: false)
        .bottomSheet(isPresented: $viewModel.showingOptions, dismiss: viewModel.dismissOptions, height: viewModel.optionsSheetHeight, content: {
                CalendarDetailOptions(viewModel: CalendarDetailOptionsViewModel(url: viewModel.url, event: viewModel.event, reminderAction: viewModel.reminderAction, shareAction: viewModel.shareAction))
        }, background: {
            Color.white
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                viewModel.animate()
            }
        }
        .onDisappear {
            viewModel.animate()
        }
    }
    
    private var closeButton: some View {
        Button(action: { withAnimation { showing = false }}) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }
    }
    
    private var editButton: some View {
        Button(action: viewModel.edit) {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.disabled(viewModel.deleted)
        .sheet(isPresented: $viewModel.showingEditView) {
            CalendarEntryEditView(viewModel: CalendarEntryEditViewModel(eventId: viewModel.eventId, dismissAction: viewModel.dismissEdit))
                .preferredColorScheme(.light)
        }
    }
    
    private var dateView: some View {
        HStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text("\(Date(timeIntervalSince1970: TimeInterval(viewModel.event.startTime)).dayAndDate)")
//                    .fontWeight(.bold)
                    .font(Font.system(size: 17, weight: .bold, design: .rounded))
                    .kerning(0.25)
                Text("\(Date(timeIntervalSince1970: TimeInterval(viewModel.event.startTime)).time) - \(Date(timeIntervalSince1970: TimeInterval(viewModel.event.endTime)).time)")
//                    .fontWeight(.bold)
                    .font(Font.system(size: 17, weight: .light, design: .rounded))
                    .kerning(0.25)
            }
            Spacer()
        }.padding()
        .background(Color.white)
        .cornerRadius(40)
        .shadow(radius: 10)
        .offset(x: UIScreen.main.bounds.width / 3 + (viewModel.animationFinished ? 0 : UIScreen.main.bounds.width / 1.5))
    }
    
    private var creatorView: some View {
        HStack {
            Text("created by %first name%".localized.replacingOccurrences(of: "%first name%", with: "\(viewModel.creatorName)"))
                .foregroundColor(.secondary)
                .font(Font.system(size: 17, weight: .light, design: .rounded))
                .kerning(0.25)
            Spacer()
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("DESCRIPTION".localized)
                    .font(Font.system(size: 13, weight: .light, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.secondary)
                Spacer()
            }.padding(.bottom, 5)
            Text(viewModel.description)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
