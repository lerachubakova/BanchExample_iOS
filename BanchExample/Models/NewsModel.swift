//
//  NewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

class NewsModel {
    private let title: String
    private let description: String
    private let date: Date
    private let source: String
    private let link: URL?

    var debugDescription: String {
        var result = ""
        result += "\n Title: \(self.title)"
        result += "\n Date: \(DateFormatter(format: "HH:mm MM-dd-yyyy").string(from: self.date))"
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
     
        if let newDate = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").date(from: jsonNews.getDate()) {
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

    func getTitle() -> String {
        return title
    }

    func getDescription() -> String {
        return description
    }

    func getSource() -> String {
        return source
    }
}

class NewsArray {
    private var news: [NewsModel] = []

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
        news.sort { $0.getDate() > $1.getDate()}
    }
}
