//
//  AnnotationView.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import Foundation
import MapKit

class AnnotationView: MKPinAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let value = newValue as? Annotation else { return }
            canShowCallout = true
            detailCalloutAccessoryView = Callout(annotation: value)
        }
    }
}
