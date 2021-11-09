//
//  SettingsViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageButton: UIButton!
    @IBOutlet private weak var privacyPolicyButton: UIButton!
    @IBOutlet private weak var termsAndConditionsButton: UIButton!

    // MARK: - Private Properties
    private weak var delegate: HomeViewControllerDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    // MARK: - Logic
    private func setLocalizedStrings() {
        mainLabel.text = LocalizeKeys.settings.localized().uppercased()
        title = LocalizeKeys.settings.localized()
        languageLabel.text = LocalizeKeys.Settings.language.localized()
        languageButton.setTitle(LocalizeKeys.Settings.languageName.localized() + " ▼", for: .normal)
        privacyPolicyButton.setTitle(LocalizeKeys.Settings.privacyPolicy.localized(), for: .normal)
        termsAndConditionsButton.setTitle(LocalizeKeys.Settings.termsAndConditions.localized(), for: .normal)
    }

    // MARK: - @IBActions
    @IBAction private func tappedMenuButton(_ sender: Any) {
        delegate?.tappedMenuButton()
    }

    @IBAction private func tappedLanguageButton(_ sender: UIButton) {
        let alertTitle = NSLocalizedString(LocalizeKeys.Settings.changeLanguage, comment: "")
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)

        let russianAction = UIAlertAction(title: "Русский", style: .default, language: "ru")

        let englishAction = UIAlertAction(title: "English", style: .default, language: "en")

        let cancelAction = UIAlertAction(title: LocalizeKeys.Settings.cancel.localized(), style: .cancel) { _ in }

        alert.addAction(russianAction)
        alert.addAction(englishAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }

    @IBAction private func tappedPrivacyPolicyButton() {

        guard let vc = UIStoryboard(name: "PolicyAndTerms", bundle: .main).instantiateInitialViewController() as? PolicyAndTermsViewController else { return }
        
        vc.setScreenType(.privacyPolicy)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func tappedTermsAndConditionsButton() {

        guard let vc = UIStoryboard(name: "PolicyAndTerms", bundle: .main).instantiateInitialViewController() as? PolicyAndTermsViewController else { return }

        vc.setScreenType(.termsAndConditions)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - LanguageSubscriber
extension SettingsViewController: LanguageSubscriber {
    func updateLanguage() {
        self.setLocalizedStrings()
    }
}
