//
//  SettingsViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.title = "App Rating"
    }

}
