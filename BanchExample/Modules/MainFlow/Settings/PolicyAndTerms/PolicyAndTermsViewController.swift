//
//  PolicyAndTermsViewController.swift
//  BanchExample
//
//  Created by User on 9.11.21.
//

import UIKit

enum PolicyAndTerms {
    case privacyPolicy
    case termsAndConditions
    case none
}

final class PolicyAndTermsViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    
    private var screenType: PolicyAndTerms = .none

    func setScreenType(_ type: PolicyAndTerms) {
        self.screenType = type
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    private func configureTextView() {
        let languagePostfix = "-" + LanguageObserver.getPreferredLanguage()
        switch screenType {
        case .privacyPolicy:
            textView.attributedText = NSAttributedString(fileName: "PrivacyPolicy" + languagePostfix, fileType: "txt", documentType: .html)
        case .termsAndConditions:
            textView.attributedText = NSAttributedString(fileName: "TermsAndConditions" + languagePostfix, fileType: "txt", documentType: .html)
        case .none:
            break
        }
    }

    func setLocalizedStrings() {
        switch screenType {
        case .privacyPolicy:
            title = LocalizeKeys.Settings.privacyPolicy.localized()
        case .termsAndConditions:
            title = LocalizeKeys.Settings.termsAndConditions.localized()
        case .none:
            break
        }
    }
}

extension PolicyAndTermsViewController: LanguageSubscriber {
    func updateLanguage() {
        setLocalizedStrings()
    }
}
