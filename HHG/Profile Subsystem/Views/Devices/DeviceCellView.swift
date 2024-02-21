//
//  DeviceCellView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 23.03.22.
//

import SwiftUI

struct DeviceCellView: View {
    
    let device: Device
    
    var body: some View {
        VStack {
            HStack {
                previewPicture
                    .padding(.trailing, 5)
                deviceInformation
                Spacer()
                arrowView
                    .padding(.trailing, 20)
            }.background(
                Color.white
                    .padding(.trailing, 30)
            )
            .padding(.all, 10)
        }.frame(width: screen.width - 30)
    }
    
    private var arrowView: some View {
        VStack {
            Spacer()
            Image(systemName: "chevron.right")
            Spacer()
        }
    }
    
    private var previewPicture: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(Color.yellow)
            .shadow(radius: 10)
            .overlay(
                device.previewImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            )
    }
    
    private var deviceInformation: some View {
        VStack(alignment: .leading) {
            Text(device.description)
                .font(Font.system(size: 16, weight: .medium, design: .rounded))
                .kerning(0.25)
            Text(device.mac)
                .foregroundColor(.gray)
                .font(Font.system(size: 15, weight: .light, design: .rounded))
                .kerning(0.25)
        }
    }
}

struct DeviceCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.mocks) { device in
            DeviceCellView(device: device)
        }
    }
}
