//
//  XMLResponseNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

final class XMLResponseNewsModel {
    let news: [XMLNewsModel]

    var count: Int {
        return news.count
    }

    var debugDescription: String {
        var result = "\n"
        _ = self.news.map {
           result += $0.debugDescription + "\n"
        }
        return result
    }

    subscript(index: Int) -> XMLNewsModel {
        guard index > -1 && index < news.count else {
            fatalError("XMLResponseNewsModel subscript index out exception")
        }
        return news[index]
    }

    init() {
        self.news = []
    }

    init?(news: [XMLNewsModel]?) {
        if news == nil { return nil }
        self.news = news!
    }

    func saveInCoreData() {
       _ = news.map { CoreDataManager.addItem(NewsModel(from: $0)) }
    }
}
