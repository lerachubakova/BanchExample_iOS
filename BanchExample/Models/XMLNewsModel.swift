//
//  XMLNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

final class XMLNewsModel {
    private var title: String = ""
    private var link: URL?
    private var author: String = ""
    private var date: Date = Date()
    private var description: String = ""

    var debugDescription: String {
        var result = ""
        result += "\n Title: \(self.title)"
        result += "\n Date: \(self.date)"
        result += "\n Description: \(self.description)"
        result += "\n Source: \(self.author)"
        result += "\n Link: \(self.link?.absoluteString ?? "")"
        return result
    }

    func addToTitle(str: String) {
        title += str
    }

    func getTitle() -> String {
        return title
    }

    func setLink(str: String) {
        link = URL(string: str)
    }

    func getLink() -> URL? {
        return link
    }

    func setAuthor(str: String) {
        author = str
    }

    func getAuthor() -> String {
        return author
    }

    func setDate(str: String) {
        let localeFromResponse = Locale(identifier: "en_BY")
        date = DateFormatter(format: "E, d MMM yyyy HH:mm:ss ZZZZ", locale: localeFromResponse).date(from: str)!
    }

    func getDate() -> Date {
        return date
    }

    func addToDescription(str: String) {
        let modifiedStr = str.replacingOccurrences(of: "\n\n", with: " ")
        description += modifiedStr
    }

    func getDescription() -> String {
        return description
    }

}
