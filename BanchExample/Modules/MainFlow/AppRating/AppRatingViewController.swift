//
//  AppRatingViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import UIKit

class AppRatingViewController: UIViewController {

    @IBOutlet private weak var mainTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings() 
        LanguageObserver.subscribe(self)
    }

    private func setLocalizedStrings() {
        mainTitleLabel.text = LocalizeKeys.appRating.localized().uppercased()
    }

}

// MARK: - LanguageSubscriber
extension AppRatingViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
    }
}
