//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

class InformationViewController: UIViewController {

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        title = "Information"

    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }
}
