//
//  UIAlertActionExtensions.swift
//  BanchExample
//
//  Created by User on 9.11.21.
//

import UIKit

extension UIAlertAction {
    convenience init(title: String, style: UIAlertAction.Style, language: String) {
        self.init(title: title, style: style) { _ in
            LanguageObserver.setPreferredLanguage(str: language)
        }
    }
}
