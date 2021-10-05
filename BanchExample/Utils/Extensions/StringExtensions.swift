//
//  StringExtensions.swift
//  BanchExample
//
//  Created by User on 4.10.21.
//

import Foundation

extension String {
    func localized() -> String {

        var path = Bundle.main.path(forResource: LanguageObserver.getPreferredLanguage(), ofType: "lproj")

        if path == nil {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }

        guard let strongPath = path else {
            print("\n LOG localized(): path is not found")
            return self
        }

        let bundle = Bundle(path: strongPath)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

}
