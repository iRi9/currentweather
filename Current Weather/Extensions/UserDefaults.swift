//
//  UserDefaults.swift
//  Current Weather
//
//  Created by Giri Bahari on 13/08/22.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let TEMPERATURE_SCALE = "TEMPERATURE_SCALE"
        static let COORDINATE_LATITUDE = "COORDINATE_LATITUDE"
        static let COORDINATE_LONGITUDE = "COORDINATE_LONGITUDE"
    }

    class var scale: TemperatureScale {
        get {
            let raw = UserDefaults.standard.string(forKey: Keys.TEMPERATURE_SCALE)
            return TemperatureScale(rawValue: raw ?? TemperatureScale.celcius.rawValue)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.TEMPERATURE_SCALE)
        }
    }
    class var latitude: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.COORDINATE_LATITUDE) ?? "-6.2"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.COORDINATE_LATITUDE)
        }
    }
    class var longitude: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.COORDINATE_LONGITUDE) ?? "106.87"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.COORDINATE_LONGITUDE)
        }
    }
}
