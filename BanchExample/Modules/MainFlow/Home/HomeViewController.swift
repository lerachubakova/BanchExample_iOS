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
    @IBOutlet private weak var showAlertButton: UIButton!

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }
        configureButton()
        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    private func configureButton() {
        showAlertButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }

    private func setLocalizedStrings() {
        title = LocalizeKeys.home.localized()
        mainLabel.text = LocalizeKeys.home.localized().uppercased()
        showAlertButton.setTitle(LocalizeKeys.showAlert.localized(), for: .normal)
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }
    
    @IBAction private func tappedShowAlertButton(_ sender: Any) {
        let popUpWindow = PopUpWindow(title: LocalizeKeys.alertTitle.localized(), text: LocalizeKeys.alertText.localized(), buttontext: LocalizeKeys.alertButton.localized())
        self.present(popUpWindow, animated: true, completion: nil)
    }

}

// MARK: - LanguageSubscriber
extension HomeViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
    }
}
