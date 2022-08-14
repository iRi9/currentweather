//
//  Annotation.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let city: String
    let weatherStatus: String
    let temperature: String
    let windSpeed: String
    let humidity: String

    init(viewModel: WeatherMapViewModel) {
        coordinate = viewModel.coordinate
        city = viewModel.city
        weatherStatus = viewModel.weather
        temperature = viewModel.temperature
        windSpeed = viewModel.windSpeed
        humidity = viewModel.humidity
    }
}
