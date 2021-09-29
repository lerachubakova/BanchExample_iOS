//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.parent?.title = "App Rating"
    }

}
