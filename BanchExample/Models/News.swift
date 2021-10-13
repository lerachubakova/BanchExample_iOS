//
//  News.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

class News {
    private var title: String
    private var link: String
    private var author: String
    private var date: String
    private var description: String

    var debugDescription: String {
        "\ntitle: \n\(title)\nlink: \n\(link)\nauthor: \n\(author)\ndate: \n\(date)\ndescription: \n\(description)"
    }

    init() {
        title = ""
        link = ""
        author = ""
        date = ""
        description = ""
    }

    func addToTitle(str: String) {
        title += str
    }

    func setLink(str: String) {
        link = str
    }

    func setAuthor(str: String) {
        author = str
    }

    func setDate(str: String) {
        date = str
    }

    func addToDescription(str: String) {
        description += str
    }

}
