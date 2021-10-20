//
//  ProjectConstants.swift
//  BanchExample
//
//  Created by User on 4.10.21.
//

import Foundation

final class LanguageObserver {

    private static var preferredLanguage: String = "en"
    
    private static var subscribers : [WeakLanguageSubscriber] = []

    static func getPreferredLanguage() -> String {
        return preferredLanguage
    }

    static func setPreferredLanguage(str: String) {
        preferredLanguage = str
        changeSubscribersLanguage()
    }

    static func subscribe(_ subscriber: LanguageSubscriber) {
        let weakSubscriber = WeakLanguageSubscriber(value: subscriber)
        subscribers.append(weakSubscriber)
    }

    static func unsubscribe(_ subscriber: LanguageSubscriber) {
        subscribers.removeAll(where: { $0.value === subscriber })
    }

    private static func changeSubscribersLanguage() {
        subscribers.forEach { $0.value?.update() }
    }
}
