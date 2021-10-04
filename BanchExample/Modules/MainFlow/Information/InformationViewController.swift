//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet private weak var mainLabel: UILabel!
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        title = NSLocalizedString(LocalizeKeys.info.rawValue, comment: "")
        mainLabel.text = NSLocalizedString(LocalizeKeys.info.rawValue, comment: "").uppercased()
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }
}
