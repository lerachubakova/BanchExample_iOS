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
    }

    // MARK: - Setup
    private func setLocalizedStrings() {
        mainTitleLabel.text = LocalizeKeys.googleMaps.localized().uppercased()
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
