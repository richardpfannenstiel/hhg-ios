//
//  DevicesListView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.03.22.
//

import SwiftUI

struct DevicesListView: View {
    
    @StateObject var viewModel: DevicesListViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.devices.isEmpty {
                SwiftUI.ScrollView {
                    Button(action: viewModel.add) {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Spacer()
                                Image(systemName: "iphone.slash.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                Text("No devices yet added".localized)
                                    .font(Font.system(size: 20, weight: .regular, design: .rounded))
                                    .kerning(0.25)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }.foregroundColor(.secondary)
                            Spacer()
                        }.padding(.top, screen.height / 4)
                    }
                }
                .navigationTitle("Devices".localized)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            closeButton
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            addButton
                        }
                    }
            } else {
                List {
                    ForEach(viewModel.devices.sorted(by: viewModel.sort)) { device in
                        Button(action: { viewModel.edit(device) }) {
                            DeviceCellView(device: device)
                                .offset(x: -15)
                        }.buttonStyle(PlainButtonStyle())
                        
                    }
                }.sheet(isPresented: $viewModel.showingEditDevice) {
                    DeviceUpdateView(viewModel: DeviceUpdateViewModel(dismiss: viewModel.dismissEditDevice, reload: viewModel.reload, device: viewModel.selectedDevice!))
                }.navigationTitle("Devices".localized)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            closeButton
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            addButton
                        }
                    }
                .refreshable {
                    viewModel.reload()
                }
            }
            
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
        }
    }
    
    private var addButton: some View {
        Button(action: viewModel.add) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
                .sheet(isPresented: $viewModel.showingAddDevice) {
                    DeviceRegisterView(viewModel: DeviceRegisterViewModel(dismiss: viewModel.dismissAddDevice, reload: viewModel.reload))
                }
        }
    }
}

struct DevicesListView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesListView(viewModel: DevicesListViewModel(dismiss: {}))
    }
}
