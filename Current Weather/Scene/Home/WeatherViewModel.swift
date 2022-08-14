//
//  WeatherViewModel.swift
//  Current Weather
//
//  Created by Giri Bahari on 11/08/22.
//

import Foundation

final class WeatherViewModel {

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
    var currentWeatherViewModel: CurrentWeatherViewModel? {
        didSet {
            self.updateView?()
        }
    }

    private var temporaryResponse: Response? {
        didSet {
            processResponse()
        }
    }

    // MARK: Init
    private let apiService: ApiService
    init(apiService: ApiService) {
        self.apiService = apiService
    }

}

// MARK: - Network Call
extension WeatherViewModel {
    func getCurrentWeather(latitude: Double?, longitude: Double?) {

        let lat = String(format: "%.2f", latitude ?? -6.2)
        let lon = String(format: "%.2f", longitude ?? 106.87)
        UserDefaults.latitude = lat
        UserDefaults.longitude = lon

        isLoading = true
        apiService.getCurrentWeather(latitude: lat, longitude: lon) { (result: Result<Response, ErrorResponse>) in
            self.isLoading = false
            switch result {
            case .success(let response):
                self.temporaryResponse = response
            case .failure(let error):
                self.alertMessage = error.message
            }
        }
    }

    private func processResponse() {
        guard let response = temporaryResponse,
              let weathers = response.weather,
              let primaryWeather = weathers.first,
              let weatherIcon = primaryWeather.icon,
              let main = response.main,
              let resHumidity = main.humidity,
              let wind = response.wind,
              let resWindSpeed = wind.speed,
              let name = response.name
        else {
            alertMessage = "Whoops... Error processing data"
            return
        }

        let temperature = (main.temp ?? 0.0).calculateTemperature()
        let windSpeed = resWindSpeed.toKph()
        let humidity = resHumidity.toPercentage()
        let iconUrl = "http://openweathermap.org/img/wn/\(weatherIcon)@4x.png"
        let temperatureScale = UserDefaults.scale.display

        let temporaryVM = CurrentWeatherViewModel(temperature: temperature,
                                                  weathedStatus: primaryWeather.main ?? "-",
                                                  windSpeed: windSpeed,
                                                  humidity: humidity,
                                                  iconUrl: iconUrl,
                                                  temperatureScale: temperatureScale,
                                                  city: name,
                                                  date: currentDate())
        currentWeatherViewModel = temporaryVM
    }

    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "EEEE, dd MMMM"

        return dateFormatter.string(from: date)
    }
}

// MARK: - Temperature Converter
extension WeatherViewModel {
    func changeTemperatureScale(to scale: TemperatureScale = .celcius) {
        UserDefaults.scale = scale
        processResponse()
    }
}

struct CurrentWeatherViewModel {
    var temperature: String
    var weathedStatus: String
    var windSpeed: String
    var humidity: String
    var iconUrl: String
    var temperatureScale: String
    var city: String
    var date: String
}

enum TemperatureScale: String {
    case fahrenheit
    case celcius

    var display: String {
        switch self {
        case .fahrenheit:
            return "ºF"
        case .celcius:
            return "ºC"
        }
    }
    var displaySlim: String {
        switch self {
        case .fahrenheit:
            return "F"
        case .celcius:
            return "C"
        }
    }
}
