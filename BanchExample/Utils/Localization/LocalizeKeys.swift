//
//  Localize.swift
//  BanchExample
//
//  Created by User on 4.10.21.
//

import Foundation

struct LocalizeKeys {
    // SideMenu
    static let home = "home"
    static let info = "photoLibrary"
    static let googleMaps = "googleMaps"
    static let shareApp = "share"
    static let settings = "settings"
    static let footer = "footer"
    static let header = "header"

    // Settings
    static let language = "language"
    static let languageName = "languageName"
    static let changeLanguage = "changeLanguage"
    static let cancel = "cancel"

    // Alerts
    class Alerts {
        static let showAlert = "showAlert"
        static let alertTitle = "alertTitle"
        static let alertText = "alertText"
        static let alertButton = "alertButton"
        static let alertSkipButton = "alertSkipButton"
        static let alertMissedLink = "alertMissedLink"
        static let alertMissedLinkSource = "alertMissedLinkSource"
        static let alertRequestError = "alertRequestError"

        static let continueTitle = "alertContinueTitle"
        static let photoLibraryMessage = "alertLibraryMessage"
        static let openSettingsButton = "alertOpenSettingsButton"
        static let noThanksButton = "alertNoThanksButton"
    }

    // PHLibrary
    class PHLibrary {
        static let photoLibraryNoPhotoMessage = "EmptyLibraryMessage"
        static let photoLibraryNoPermission = "NoPermissionsPhotoLibrary"
    }

    // Filters
    class Filters {
        static let all = "allFilter"
        static let withoutDeleted = "withoutDeletedFilter"
        static let interesting = "interestingFilter"
        static let trash = "trashFilter"
        static let hidden = "hiddenFilter"
    }
}
