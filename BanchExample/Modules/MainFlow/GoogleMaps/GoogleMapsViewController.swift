//
//  AppRatingViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import UIKit

final class GoogleMapsViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var mapView: GMSMapView!

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()

    // MARK: - Public Properties
    weak var delegate: HomeViewControllerDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        setLocalizedStrings() 
        LanguageObserver.subscribe(self)
        configureLocationManager()
    }

    // MARK: - Setup
    private func setLocalizedStrings() {
        mainTitleLabel.text = LocalizeKeys.googleMaps.localized().uppercased()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - @IBActions
    @IBAction private func tappedMenuButton(_ sender: Any) {
        delegate?.tappedMenuButton()
    }
}

// MARK: - LanguageSubscriber
extension GoogleMapsViewController: LanguageSubscriber {
    func updateLanguage() {
        self.setLocalizedStrings()
    }
}

// MARK: - CLLocationManagerDelegate
extension GoogleMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()

            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

}
