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

    init() {
        self.news = []
    }

    init(news: [JSONNewsModel]) {
        self.news = news
    }
}

struct JSONNewsModel: Codable {
    private let title: String
    private let link: URL?
    private let date: String
    private let source: SourceModel
    private let description: String?

    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "url"
        case date = "publishedAt"
        case source = "source"
        case description = "description"
    }

    init() {
        title = ""
        link = nil
        date = ""
        source = SourceModel()
        description = nil
    }

    init(title: String, link: URL, author: String, date: String, description: String, source: SourceModel) {
        self.title = title
        self.link = link
        self.date = date
        self.source = source
        self.description = description
    }

    var debugDescription: String {
        var result = ""
        result += "\n Title: \(self.title)"
        result += "\n Date: \(self.date)"
        result += "\n Description: \(self.description ?? "")"
        result += "\n Source: \(self.source.debugDescription)"
        result += "\n Link: \(self.link?.absoluteString ?? "")"
        return result
    }

}

struct SourceModel: Codable {
    private var name = ""

    var debugDescription: String { self.name }
}
