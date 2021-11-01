//
//  NSDateExtensions.swift
//  BanchExample
//
//  Created by User on 1.11.21.
//

import Foundation

extension NSDate {
    convenience init(dateString: String, format: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = format
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}
