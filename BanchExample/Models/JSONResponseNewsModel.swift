//
//  JSONResponseNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

struct JSONResponseNewsModel: Codable {
    let news: [JSONNewsModel]

    private enum CodingKeys: String, CodingKey {
        case news = "articles"
    }

    var debugDescription: String {
        var result = "\n"
        _ = self.news.map {
           result += $0.debugDescription + "\n"
        }
        return result
    }

    var count: Int {
        return news.count
    }

    init() {
        self.news = []
    }

    init(news: [JSONNewsModel]) {
        self.news = news
    }

    subscript(index: Int) -> JSONNewsModel {
        guard index > -1 && index < news.count else {
            fatalError("JSONResponseNewsModel subscript index out exception")
        }
        return news[index]
    }
}
