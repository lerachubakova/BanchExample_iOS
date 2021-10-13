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

    private var news: [News]?

    func getNews(from data: Data) -> [News]? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return news
    }

}

extension NewsXMLParser : XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "item":
            if news == nil { news = [] }
            self.item += 1
            news?.append(News())
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
            self.news?.last?.setLink(str: data)
        case "description":
            self.news?.last?.addToDescription(str: string)
        case "title":
            self.news?.last?.addToTitle(str: string)
        case "author":
            self.news?.last?.setAuthor(str: data)
        case "pubDate":
            self.news?.last?.setDate(str: data)
        default:
            break
        }
    }
}
