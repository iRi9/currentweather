//
//  Callout.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import UIKit

class Callout: UIView {
    private let lblCity = UILabel(frame: .zero)
    private let lblTemperature = UILabel(frame: .zero)
    private let lblWeatherStatus = UILabel(frame: .zero)
    private let lblWindSpeed = UILabel(frame: .zero)
    private let lblHumidity = UILabel(frame: .zero)
    private let lblCoordinate = UILabel(frame: .zero)

    private let annotation: Annotation

    init(annotation: Annotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupCity()
        setupTemperature()
        setupWeather()
        setupWindSpeed()
        setupHumidity()
        setupCoordinate()
    }

    private func setupCity() {
        lblCity.font = UIFont.boldSystemFont(ofSize: 20)
        lblCity.text = annotation.city
        addSubview(lblCity)
        lblCity.translatesAutoresizingMaskIntoConstraints = false
        lblCity.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lblCity.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lblCity.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func setupTemperature() {
        lblTemperature.font = UIFont.systemFont(ofSize: 14)
        lblTemperature.textColor = UIColor.label
        lblTemperature.text = "Temperature: \(annotation.temperature)"
        addSubview(lblTemperature)
        lblTemperature.translatesAutoresizingMaskIntoConstraints = false
        lblTemperature.topAnchor.constraint(equalTo: lblCity.bottomAnchor, constant: 8).isActive = true
        lblTemperature.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lblTemperature.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func setupWeather() {
        lblWeatherStatus.font = UIFont.systemFont(ofSize: 14)
        lblWeatherStatus.textColor = UIColor.label
        lblWeatherStatus.text = "Weather Status: \(annotation.weatherStatus)"
        addSubview(lblWeatherStatus)
        lblWeatherStatus.translatesAutoresizingMaskIntoConstraints = false
        lblWeatherStatus.topAnchor.constraint(equalTo: lblTemperature.bottomAnchor, constant: 8).isActive = true
        lblWeatherStatus.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lblWeatherStatus.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func setupWindSpeed() {
        lblWindSpeed.font = UIFont.systemFont(ofSize: 14)
        lblWindSpeed.textColor = .gray
        lblWindSpeed.text = "Wind Speed: \(annotation.windSpeed)"
        addSubview(lblWindSpeed)
        lblWindSpeed.translatesAutoresizingMaskIntoConstraints = false
        lblWindSpeed.topAnchor.constraint(equalTo: lblWeatherStatus.bottomAnchor, constant: 8).isActive = true
        lblWindSpeed.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lblWindSpeed.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func setupHumidity() {
        lblHumidity.font = UIFont.systemFont(ofSize: 14)
        lblHumidity.textColor = .gray
        lblHumidity.text = "Humidity: \(annotation.humidity)"
        addSubview(lblHumidity)
        lblHumidity.translatesAutoresizingMaskIntoConstraints = false
        lblHumidity.topAnchor.constraint(equalTo: lblWindSpeed.bottomAnchor, constant: 8).isActive = true
        lblHumidity.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lblHumidity.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func setupCoordinate() {
        lblCoordinate.font = UIFont.systemFont(ofSize: 14)
        lblCoordinate.textColor = .gray
        lblCoordinate.text = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        addSubview(lblCoordinate)
        lblCoordinate.translatesAutoresizingMaskIntoConstraints = false
        lblCoordinate.topAnchor.constraint(equalTo: lblHumidity.bottomAnchor, constant: 8).isActive = true
        lblCoordinate.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lblCoordinate.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lblCoordinate.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
