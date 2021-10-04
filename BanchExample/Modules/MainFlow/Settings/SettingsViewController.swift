//
//  SettingsViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var mainLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainLabel.text = NSLocalizedString(LocalizeKeys.settings.rawValue, comment: "").uppercased()
    }

}
