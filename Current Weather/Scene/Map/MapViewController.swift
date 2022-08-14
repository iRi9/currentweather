//
//  MapViewController.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private lazy var viewModel: MapViewModel = {
        let vm = MapViewModel(apiService: ApiService())
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didLongTapMapView))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        mapView.center(to: CLLocationCoordinate2D(latitude: Double(UserDefaults.latitude)!, longitude: Double(UserDefaults.longitude)!),
                       regionRadius: 15000)

        setupViewModel()
    }

    fileprivate func addAnnotation(_ weather: WeatherMapViewModel) {
        let annotation = Annotation(viewModel: weather)
        mapView.addAnnotation(annotation)
    }

    @objc
    private func didLongTapMapView(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let lat = Double(coordinate.latitude)
        let lon = Double(coordinate.longitude)
        viewModel.getLocationWeather(latitude: lat, longitude: lon)
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
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }

        viewModel.updateView = {
            DispatchQueue.main.async { [weak self] in
                guard let weather = self?.viewModel.weatherMapViewModel else {
                    self?.showAlert(message: "Empty data")
                    return
                }
                self?.addAnnotation(weather)
            }
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if let annotation = annotation as? Annotation {
          annotationView?.canShowCallout = true
          annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
        }
        return annotationView

    }
}
