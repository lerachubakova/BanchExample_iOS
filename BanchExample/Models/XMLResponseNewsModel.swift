//
//  XMLResponseNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

class XMLResponseNewsModel {
    let news: [XMLNewsModel]

    var debugDescription: String {
        var result = "\n"
        _ = self.news.map {
           result += $0.debugDescription + "\n"
        }
        return result
    }

    init() {
        self.news = []
    }

    init?(news: [XMLNewsModel]?) {
        if news == nil { return nil }
        self.news = news!
    }
}
