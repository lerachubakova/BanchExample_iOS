//
//  NetworkManager.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation

final class NetworkManager: NSObject {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    private var elementName = ""
    private var item = -1

    private var news: [News]?

    func makeXMLNewsRequest(completion: @escaping ([News]?) -> Void) {
        guard let url = URL(string: "https://www.gazeta.ru/export/rss/lenta.xml") else { return }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n Error: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response {
                 print("\n", strongResponse.debugDescription)
            }

            if let data = data {
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()

                completion(self.news)
            }
        }
        dataTask?.resume()
    }
}

extension NetworkManager : XMLParserDelegate {

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
