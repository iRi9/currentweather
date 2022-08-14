//
//  Double.swift
//  Current Weather
//
//  Created by Giri Bahari on 13/08/22.
//

import Foundation

extension Double {
    func toCelcius() -> String {
        let celcius = self - 273.15
        return String(format: "%.0fº", celcius)
    }

    func toFahrenheit() -> String {
        let fahrenheit = ((self - 273.15) * 1.8) + 32
        return String(format: "%.0fº", fahrenheit)
    }

    func toKph() -> String {
        let kph = self * 3.6
        return String(format: "%.0f km/h", kph)
    }

    func toPercentage() -> String {
        return String(format: "%.0f%%", self)
    }

    func calculateTemperature() -> String {
        switch UserDefaults.scale {
        case .fahrenheit: return self.toFahrenheit()
        case .celcius: return self.toCelcius()
        }
    }
}
