//
//  CalendarEntryEditView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 11.10.21.
//

import SwiftUI

struct CalendarEntryEditView: View {
    
    @StateObject var viewModel: CalendarEntryEditViewModel
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    closeButton
                    Spacer()
                }
                titleAndCategory
                dateView
                descriptionView
                if !viewModel.sendingDeleteRequest {
                    addButtonView
                }
                if !viewModel.sendingEditRequest {
                    deleteButtonView
                }

                
                Spacer()
            }.onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
            if viewModel.showingCategorySelector {
                categorySelectionView
            }
        }.background(
            backgroundView
        ).subtileAlert(isShowing: $viewModel.showingAlert, title: viewModel.alertTitle, subtitle: viewModel.alertSubtitle, image: viewModel.alertImage, showingClose: false, specialPadding: 10)
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: viewModel.close) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var titleAndCategory: some View {
        VStack {
            TextField("Title".localized, text: $viewModel.title)
                .padding(.horizontal)
            Divider()
                .padding(.horizontal)
            Button(action: viewModel.showCategorySelector, label: {
                HStack {
                    Text(viewModel.category?.title ?? "Category".localized)
                        .foregroundColor(viewModel.category != nil ? Color(.black) : Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
                        .padding(.horizontal)
                    Spacer()
                }.background(Color.white)
            }).buttonStyle(PlainButtonStyle())
        }.padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var categorySelectionView: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect.init(style: .systemChromeMaterialLight))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                categorySelector
                    .scaleEffect(viewModel.animationAmount)
                    .animation(.interpolatingSpring(stiffness: 150, damping: 18))
                Spacer()
                Button(action: { withAnimation { viewModel.dismissCategorySelector(category: nil) }}) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 70, height: 70)
                }.scaleEffect(viewModel.animationAmount)
                .animation(.interpolatingSpring(stiffness: 150, damping: 18))
                Spacer()
            }
        }
    }
    
    private var dateView: some View {
        VStack {
            Toggle(isOn: $viewModel.allDay, label: {
                Text("All-day".localized)
            }).padding(.horizontal)
            Divider()
                .padding(.horizontal)
            DatePicker("Starts".localized, selection: viewModel.startDateProxy)
                .padding(.horizontal)
                .preferredColorScheme(.light)
            DatePicker("Ends".localized, selection: viewModel.endDateProxy)
                .padding(.horizontal)
                .preferredColorScheme(.light)
        }.padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var descriptionView: some View {
        VStack {
            HStack {
                TextField("URL", text: $viewModel.url)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                Spacer()
                Button(action: viewModel.pasteURL, label: {
                    Image(systemName: "doc.on.clipboard")
                        .padding(.trailing)
                })
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 5)
            ZStack {
                TextEditor(text: $viewModel.description)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                VStack {
                    HStack(alignment: .bottom) {
                        Text(viewModel.description.isEmpty ? "Description".localized : "")
                            .foregroundColor(Color(#colorLiteral(red: 0.7685185075, green: 0.7685293555, blue: 0.7766974568, alpha: 1)))
                            .padding(.top, 10)
                        Spacer()
                    }
                    Spacer()
                }
            }.padding(.horizontal)
            .frame(height: 100)
                
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var addButtonView: some View {
        Button(action: viewModel.edit) {
            HStack {
                Spacer()
                Text(viewModel.sendingEditRequest ? "" : "Update".localized)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingEditRequest {
                                if viewModel.eventEditedSuccessfully {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical)
                                }
                            } else {
                                Text("")
                            }
                        }
                    )
                Spacer()
            }
            .frame(width: viewModel.sendingEditRequest ? 60 : UIScreen.main.bounds.width - 30, height: 60)
        }.disabled(!viewModel.validEntry)
        .background(viewModel.validEntry ? Color.HHG_Blue : Color.gray)
        .cornerRadius(viewModel.sendingEditRequest ? 50 : 15)
        .padding(.top, 20)
    }
    
    private var deleteButtonView: some View {
        Button(action: viewModel.delete) {
            HStack {
                Spacer()
                Text(viewModel.sendingDeleteRequest ? "" : "Delete".localized)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .overlay(
                        Group {
                            if viewModel.sendingDeleteRequest {
                                if viewModel.eventDeltedSuccessfully {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical)
                                }
                            } else {
                                Text("")
                            }
                        }
                    )
                Spacer()
            }
            .frame(width: viewModel.sendingDeleteRequest ? 60 : UIScreen.main.bounds.width - 30, height: 60)
        }.background(Color.red)
        .cornerRadius(viewModel.sendingDeleteRequest ? 50 : 15)
        .padding(.top, 5)
    }
    
    private var addedSuccessfully: some View {
        HStack {
            Spacer()
            Text("Add".localized)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.clear)
                .overlay(
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                )
            Spacer()
        }.frame(width: 100)
        .background(Color.HHG_Blue)
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    private var categorySelector: some View {
        HStack {
            SwiftUI.ScrollView(.vertical) {
                ForEach(CalendarStore.shared.categories.filter({ $0.canCreate })) { category in
                    Button(action: { viewModel.dismissCategorySelector(category: category) }, label: {
                        HStack {
                            Rectangle()
                                .foregroundColor(category.backgroundColor)
                                .frame(width: UIScreen.main.bounds.width - 75, height: 50, alignment: .center)
                                .cornerRadius(15)
                                .overlay(
                                    Text(category.title)
                                        .foregroundColor(category.fontColor)
                                )
                        }
                    })
                }
            }
        }.padding()
        .frame(height: UIScreen.main.bounds.height / 2, alignment: .center)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
        .animation(.default)
        .shadow(radius: 10)
    }
}

struct CalendarEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarEntryEditView(viewModel: CalendarEntryEditViewModel(eventId: CalendarEvent.mock.id, dismissAction: {}))
    }
}
