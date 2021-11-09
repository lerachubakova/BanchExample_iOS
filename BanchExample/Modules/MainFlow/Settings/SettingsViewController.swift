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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    // MARK: - Logic
    private func setLocalizedStrings() {
        languageButton.setTitle(LocalizeKeys.languageName.localized() + " ▼", for: .normal)
        mainLabel.text = LocalizeKeys.settings.localized().uppercased()
        languageLabel.text = LocalizeKeys.language.localized()
    }

    // MARK: - @IBActions
    @IBAction private func tappedLanguageButton(_ sender: UIButton) {
    let alertTitle = NSLocalizedString(LocalizeKeys.changeLanguage, comment: "")
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)

        let russianAction = UIAlertAction(title: "Русский", style: .default, language: "ru")

        let englishAction = UIAlertAction(title: "English", style: .default, language: "en")

        let cancelAction = UIAlertAction(title: LocalizeKeys.cancel.localized(), style: .cancel) { _ in }

        alert.addAction(russianAction)
        alert.addAction(englishAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
}

// MARK: - LanguageSubscriber
extension SettingsViewController: LanguageSubscriber {
    func updateLanguage() {
        self.setLocalizedStrings()
    }
}
