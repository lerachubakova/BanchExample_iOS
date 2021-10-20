//
//  NewsArray.swift
//  BanchExample
//
//  Created by User on 15.10.21.
//

import Foundation

final class NewsArray {
    private var news: [NewsModel] = []

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

    subscript(index: Int) -> NewsModel {
        guard index > -1 && index < news.count else {
            fatalError("XMLResponseNewsModel subscript index out exception \(index)")
        }
        return news[index]
    }

    func append(element: XMLNewsModel) {
        news.append(NewsModel(from: element))
    }

    func append(element: JSONNewsModel) {
        news.append(NewsModel(from: element))
    }

    func append(array: JSONResponseNewsModel) {
        for i in (0..<array.count) {
            news.append(NewsModel(from: array[i]))
        }
    }

    func append(array: XMLResponseNewsModel) {
        for i in (0..<array.count) {
            news.append(NewsModel(from: array[i]))
        }
    }

    func sort() {
        news.sort { $0.date > $1.date}
    }

    func saveInCoreData() {
        _ = news.map { CoreDataManager.addItem($0) }
    }
}
