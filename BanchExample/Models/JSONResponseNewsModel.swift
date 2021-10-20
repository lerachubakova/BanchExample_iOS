//
//  JSONResponseNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

struct JSONResponseNewsModel: Codable {
    var news: [JSONNewsModel] = []

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

    private enum CodingKeys: String, CodingKey {
        case news = "articles"
    }

    subscript(index: Int) -> JSONNewsModel {
        guard index > -1 && index < news.count else {
            fatalError("JSONResponseNewsModel subscript index out exception")
        }
        return news[index]
    }

    init(news: [JSONNewsModel]) {
        self.news = news
    }

    func saveInCoreData() {
        _ = news.map { CoreDataManager.addItem(NewsModel(from: $0))}
    }
}
