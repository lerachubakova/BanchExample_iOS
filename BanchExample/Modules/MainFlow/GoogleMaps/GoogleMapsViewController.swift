//
//  AppRatingViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import GoogleMaps
import UIKit

final class GoogleMapsViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet private weak var mapView: GMSMapView!

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private weak var delegate: HomeViewControllerDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        configureLocationManager()
    }

    // MARK: - Setup
    private func configureLocationManager() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - @IBActions
    @IBAction private func tappedMenuButton(_ sender: Any) {
        delegate?.tappedMenuButton()
    }
}

// MARK: - CLLocationManagerDelegate
extension GoogleMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("GoogleMapsViewController: locationManager: \(error.localizedDescription)")
    }
}
