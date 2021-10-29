//
//  LanguageSubscriber.swift
//  BanchExample
//
//  Created by User on 5.10.21.
//

import Foundation

protocol LanguageSubscriber : AnyObject {
    func updateLanguage()
}

struct WeakLanguageSubscriber {
    weak var value : LanguageSubscriber?
}
