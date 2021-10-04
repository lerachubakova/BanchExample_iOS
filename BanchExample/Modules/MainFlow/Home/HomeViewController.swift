//
//  HomeViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func tappedMenuButton()
}

class HomeViewController: UIViewController {

    @IBOutlet private weak var mainLabel: UILabel!

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString(LocalizeKeys.home.rawValue, comment: "")
        mainLabel.text = NSLocalizedString(LocalizeKeys.home.rawValue, comment: "").uppercased()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }
        
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

}
