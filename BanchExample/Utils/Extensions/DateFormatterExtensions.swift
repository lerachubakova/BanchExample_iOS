//
//  DateFormatterExtensions.swift
//  BanchExample
//
//  Created by User on 14.10.21.
//

import Foundation

extension DateFormatter {
    convenience init(format: String, locale: Locale? = nil) {
        self.init()
        self.dateFormat = format
        if locale != nil {
            self.locale = locale!
        }
    }
}
