//
//  WeatherViewController.swift
//  Current Weather
//
//  Created by Giri Bahari on 13/08/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var imgIconWeather: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!

    private lazy var viewModel: WeatherViewModel = {
        let vm = WeatherViewModel(apiService: ApiService())
        return vm
    }()
    private var btnTemperatureScale = UIBarButtonItem()
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationPermission()
        setupViewModel()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocationManager()
    }

    private func setupView() {
        viewLoading.layer.cornerRadius = 5
        viewLoading.clipsToBounds = true
        viewLoading.isHidden = true

        btnTemperatureScale = UIBarButtonItem(title: UserDefaults.scale.display,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapTempScale))
        btnTemperatureScale.tintColor = UIColor.label

        let btnMap = UIBarButtonItem(image: UIImage(systemName: "map"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapMap))
        btnMap.tintColor = UIColor.label

        navigationItem.leftBarButtonItem = btnTemperatureScale
        navigationItem.rightBarButtonItem = btnMap
    }

    private func setupViewModel() {
        viewModel.updateAlertMessage = {
            DispatchQueue.main.async { [weak self] in
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message: message)
                }
            }
        }
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                if self?.viewModel.isLoading ?? false {
                    self?.viewLoading.isHidden = false
                } else {
                    self?.viewLoading.isHidden = true
                }
            }
        }
        viewModel.updateView = {
            DispatchQueue.main.async { [weak self] in
                self?.updateView(with: self?.viewModel.currentWeatherViewModel)
            }
        }
    }

    private func updateView(with viewModel: CurrentWeatherViewModel?) {
        guard let viewModel = viewModel else {
            return
        }

        imgIconWeather.setImage(with: viewModel.iconUrl)
        lblCity.text = viewModel.city
        lblTemperature.text = viewModel.temperature
        lblWeatherStatus.text = viewModel.weathedStatus
        lblDate.text = viewModel.date
        lblWindSpeed.text = viewModel.windSpeed
        lblHumidity.text = viewModel.humidity
        btnTemperatureScale.title = viewModel.temperatureScale
    }

    @objc
    private func didTapTempScale() {
        let newScale = UserDefaults.scale == .celcius ? TemperatureScale.fahrenheit : TemperatureScale.celcius
        viewModel.changeTemperatureScale(to: newScale)
    }

    @objc
    private func didTapMap() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            locationManager.requestWhenInUseAuthorization()
            viewModel.getCurrentWeather(latitude: nil, longitude: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.getCurrentWeather(latitude: locationValue.latitude, longitude: locationValue.longitude)
    }
}
