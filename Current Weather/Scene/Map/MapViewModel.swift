//
//  MapViewModel.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import Foundation
import CoreLocation
import MapKit

final class MapViewModel {
    // MARK: Binding
    var updateLoadingStatus: (() -> Void)?
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }

    var updateAlertMessage: (() -> Void)?
    var alertMessage: String? {
        didSet {
            self.updateAlertMessage?()
        }
    }

    var updateView: (() -> Void)?
    var weatherMapViewModel: WeatherMapViewModel? {
        didSet {
            self.updateView?()
        }
    }

    // MARK: Init
    private let apiService: ApiService
    init(apiService: ApiService) {
        self.apiService = apiService
    }
}

// MARK: - Network Call
extension MapViewModel {
    func getLocationWeather(latitude: Double, longitude: Double) {
        
        let lat = String(format: "%.2f", latitude)
        let lon = String(format: "%.2f", longitude)

        isLoading = true
        apiService.getCurrentWeather(latitude: lat, longitude: lon) { (result: Result<Response, ErrorResponse>) in
            self.isLoading = false
            switch result {
            case .success(let response):
                self.processResponse(response)
            case .failure(let error):
                self.alertMessage = error.message
            }
        }
    }

    private func processResponse(_ response: Response) {
        guard let weathers = response.weather,
              let primaryWeather = weathers.first,
              let main = response.main,
              let resHumidity = main.humidity,
              let wind = response.wind,
              let resWindSpeed = wind.speed,
              let coord = response.coord,
              let lat = coord.lat,
              let lon = coord.lon,
              let city = response.name
        else {
            alertMessage = "Whoops... Error processing data"
            return
        }

        let temperature = (main.temp ?? 0.0).calculateTemperature()
        let windSpeed = resWindSpeed.toKph()
        let humidity = resHumidity.toPercentage()
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        weatherMapViewModel = WeatherMapViewModel(coordinate: coordinate,
                                                  city: city,
                                                  temperature: "\(temperature)\(UserDefaults.scale.displaySlim)",
                                                  weather: primaryWeather.main ?? "-",
                                                  windSpeed: windSpeed,
                                                  humidity: humidity)
    }

}

struct WeatherMapViewModel {
    var coordinate: CLLocationCoordinate2D
    var city: String
    var temperature: String
    var weather: String
    var windSpeed: String
    var humidity: String
}
