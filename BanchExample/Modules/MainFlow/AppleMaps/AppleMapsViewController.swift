//
//  AppleMapsViewController.swift
//  BanchExample
//
//  Created by User on 3.11.21.
//

import CoreLocation
import MapKit
import UIKit

final class AppleMapsViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!

    private weak var delegate: HomeViewControllerDelegate?

    private let locationManager = CLLocationManager()
    private var isFirstUpdate = true

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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - @IBActions
    @IBAction private func tappedMenuButton(_ sender: Any) {
        delegate?.tappedMenuButton()
    }

    @IBAction private func tappedMyLocationButton (_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}

extension AppleMapsViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            let center = location.coordinate
            let delta = 0.02
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: center, span: span)

            mapView.setRegion(region, animated: !isFirstUpdate)
            isFirstUpdate = false
            locationManager.stopUpdatingLocation()
        }
    }

   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("AppleMapsViewController: locationManager: \(error.localizedDescription)")
   }
}
