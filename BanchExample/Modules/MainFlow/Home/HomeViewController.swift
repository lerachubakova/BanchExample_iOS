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

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }
        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    private func setLocalizedStrings() {
        title = LocalizeKeys.home.localized()
        mainLabel.text = LocalizeKeys.home.localized().uppercased()
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

}

// MARK: - LanguageSubscriber
extension HomeViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
    }
}
