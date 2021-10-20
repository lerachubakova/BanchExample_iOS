//
//  StringExtensions.swift
//  BanchExample
//
//  Created by User on 4.10.21.
//

import Foundation
import SwiftSoup

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

    func parseGazetaRuHTML() -> (String, String)? {
        do {
            var result = (title: "", body: "")
            let doc: Document = try SwiftSoup.parse(self)

            let title = try doc.getElementsByClass("headline").text()
            result.title = title

            let body = try doc.getElementsByClass("b_article-text").text()
            result.body = body

            if title.isEmpty { return nil }

            return result

        } catch {
            print("\n NetworkManager: parseHTML: error")
        }
        return nil
    }
}
