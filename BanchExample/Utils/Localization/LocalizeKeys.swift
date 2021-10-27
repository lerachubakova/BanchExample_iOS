//
//  Localize.swift
//  BanchExample
//
//  Created by User on 4.10.21.
//

import Foundation

struct LocalizeKeys {
    // sideMenu
    static let home = "home"
    static let info = "info"
    static let appRating = "rating"
    static let shareApp = "share"
    static let settings = "settings"
    static let footer = "footer"
    static let header = "header"

    // settings
    static let language = "language"
    static let languageName = "languageName"
    static let changeLanguage = "changeLanguage"
    static let cancel = "cancel"

    // alerts
    class Alerts {
        static let showAlert = "showAlert"
        static let alertTitle = "alertTitle"
        static let alertText = "alertText"
        static let alertButton = "alertButton"
        static let alertSkipButton = "alertSkipButton"
        static let alertMissedLink = "alertMissedLink"
        static let alertMissedLinkSource = "alertMissedLinkSource"
        static let alertRequestError = "alertRequestError"
    }

    // filters
    class Filters {
        static let all = "allFilter"
        static let withoutDeleted = "withoutDeletedFilter"
        static let interesting = "interestingFilter"
        static let trash = "trashFilter"
        static let hidden = "hiddenFilter"
    }
}
