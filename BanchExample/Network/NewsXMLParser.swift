//
//  NewsXMLParser.swift
//  BanchExample
//
//  Created by User on 13.10.21.
//

import Foundation

final class NewsXMLParser: NSObject {
    private var elementName = ""
    private var item = -1

    private var news: [XMLNewsModel]?

    func getNews(from data: Data) -> NewsArray? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        let newsArray = NewsArray()
        if let xmlNews = XMLResponseNewsModel(news: news) {
            newsArray.append(array: xmlNews)
        }
        return newsArray
    }

}

extension NewsXMLParser : XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "item":
            if news == nil { news = [] }
            self.item += 1
            news?.insert(XMLNewsModel(), at: 0)
        default:
            break
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard !data.isEmpty && self.item > -1 else {
            return
        }

        switch self.elementName {
        case "link":
            self.news?.first?.setLink(str: data)
        case "description":
            self.news?.first?.addToDescription(str: string)
        case "title":
            self.news?.first?.addToTitle(str: string)
        case "author":
            self.news?.first?.setAuthor(str: data)
        case "pubDate":
            self.news?.first?.setDate(str: data)
        default:
            break
        }
    }
}
