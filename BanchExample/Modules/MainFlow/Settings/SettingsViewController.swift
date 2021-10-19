//
//  SettingsViewController.swift
//  BanchExample
//
//  Created by User on 29.09.21.
//

import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    private func setLocalizedStrings() {
        languageButton.setTitle(LocalizeKeys.languageName.localized() + " ▼", for: .normal)
        mainLabel.text = LocalizeKeys.settings.localized().uppercased()
        languageLabel.text = LocalizeKeys.language.localized()
    }

    private func changeLanguage(str: String) {
        LanguageObserver.setPreferredLanguage(str: str)
    }

    @IBAction private func tappedLanguageButton(_ sender: UIButton) {
    let alertTitle = NSLocalizedString(LocalizeKeys.changeLanguage, comment: "")
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)

        let russianAction = UIAlertAction(title: "Русский", style: .default) { [weak self] _ in
            self?.changeLanguage(str: "ru")
        }

        let englishAction = UIAlertAction(title: "English", style: .default) { [weak self] _ in
            self?.changeLanguage(str: "en")
        }

        alert.addAction(russianAction)
        alert.addAction(englishAction)
        self.present(alert, animated: true)
    }
}

// MARK: - LanguageSubscriber
extension SettingsViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
    }
}
