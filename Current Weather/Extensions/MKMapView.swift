//
//  MKMapView.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import Foundation
import MapKit

extension MKMapView {
    func center(to coordinate: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 4000) {
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
