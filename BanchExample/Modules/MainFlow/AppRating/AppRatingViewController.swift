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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mainTitleLabel.text = NSLocalizedString(LocalizeKeys.appRating.rawValue, comment: "").uppercased()
    }

}
