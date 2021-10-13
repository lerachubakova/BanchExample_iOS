//
//  NewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

class News {
    private let title: String
    private let description: String
    private let date: Date
    private let source: String
    private let link: URL?

    var debugDescription: String {
        var result = ""
        result += "\n Title: \(self.title)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MM-dd-yyyy"
        result += "\n Date: \(dateFormatter.string(from: self.date))"
        result += "\n Description: \(self.description)"
        result += "\n Source: \(self.source)"
        result += "\n Link: \(self.link?.absoluteString ?? "")"
        return result
    }

    init() {
        title = ""
        description = ""
        date = Date()
        source = ""
        link = nil
    }

    init(from xmlNews: XMLNewsModel) {
        title = xmlNews.getTitle()
        description = xmlNews.getDescription()
        date = xmlNews.getDate()
        source = xmlNews.getAuthor()
        link = xmlNews.getLink()
    }

    init(from jsonNews: JSONNewsModel) {
        title = jsonNews.getTitle()
        description = jsonNews.getDescription()

        print(jsonNews.getDate())

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let newDate = dateFormatter.date(from: jsonNews.getDate()) {
            date = newDate
        } else {
            date = ISO8601DateFormatter().date(from: jsonNews.getDate())!
        }

        source = jsonNews.getAuthor()
        link = jsonNews.getLink()
    }

    func getDate() -> Date {
        return date
    }
}

class NewsArray {
    private var news: [News] = []

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

    subscript(index: Int) -> News {
        guard index > -1 && index < news.count else {
            fatalError("XMLResponseNewsModel subscript index out exception")
        }
        return news[index]
    }

    func append(element: XMLNewsModel) {
        news.append(News(from: element))
    }

    func append(element: JSONNewsModel) {
        news.append(News(from: element))
    }

    func append(array: JSONResponseNewsModel) {
        for i in (0..<array.count) {
            news.append(News(from: array[i]))
        }
    }

    func append(array: XMLResponseNewsModel) {
        for i in (0..<array.count) {
            news.append(News(from: array[i]))
        }
    }

    func sort() {
        news.sort { $0.getDate() < $1.getDate()}
    }
}
