//
//  MapView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 10.07.21.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.00008, longitudeDelta: 0.00008)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.mapType = MKMapType.satelliteFlyover
        uiView.setRegion(region, animated: true)
    }
}
