//
//  NewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

final class NewsModel {
    let title: String
    let description: String
    let date: Date
    let source: String
    let link: URL?

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
        title = jsonNews.title
        description = jsonNews.description ?? ""
     
        if let newDate = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").date(from: jsonNews.date) {
            date = newDate
        } else {
            date = ISO8601DateFormatter().date(from: jsonNews.date)!
        }

        source = jsonNews.source.debugDescription
        link = jsonNews.link
    }

}
