//
//  JSONNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

struct JSONNewsModel: Codable {
    let title: String
    let link: URL?
    let date: String
    let source: SourceModel
    let description: String?

    var debugDescription: String {
        var result = ""
        result += "\n Title: \(self.title)"
        result += "\n Date: \(self.date)"
        result += "\n Description: \(self.description ?? "")"
        result += "\n Source: \(self.source.debugDescription)"
        result += "\n Link: \(self.link?.absoluteString ?? "")"
        return result
    }

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
}
