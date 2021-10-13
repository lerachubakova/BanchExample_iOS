//
//  XMLNewsModel.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

class XMLNewsModel {
    private var title = ""
    private var link = ""
    private var author = ""
    private var date = ""
    private var description = ""

    var debugDescription: String {
        var result = ""
        result += "\n Title: \(self.title)"
        result += "\n Date: \(self.date)"
        result += "\n Description: \(self.description)"
        result += "\n Source: \(self.author)"
        result += "\n Link: \(self.link)"
        return result
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
        let modifiedStr = str.replacingOccurrences(of: "\n\n", with: " ")
        description += modifiedStr
    }

}
