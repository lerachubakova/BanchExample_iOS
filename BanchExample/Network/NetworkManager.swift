//
//  NetworkManager.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation
import SwiftSoup

final class NetworkManager: NSObject {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    func makeXMLNewsRequest(completion: @escaping (XMLResponseNewsModel?) -> Void) {
        guard let url = URL(string: "https://www.gazeta.ru/export/rss/lenta.xml") else { return }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n NetworkManager: makeXMLNewsRequest: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response as? HTTPURLResponse {
                if strongResponse.statusCode != 200 {
                    print("\n", strongResponse.debugDescription)
                }
            }

            if let data = data {
                DispatchQueue.main.async {
                    let news = NewsXMLParser().getNews(from: data)
                    completion(news)
                }
            } else {
                print("\n NetworkManager: makeXMLNewsRequest no data. ")
            }
        }
        dataTask?.resume()
    }

    func makeJSONNewsRequest(completion: @escaping (JSONResponseNewsModel?) -> Void) {

        guard var urlComponents = URLComponents(string: APIConstants.baseURL) else { return }

        urlComponents.queryItems =
            [
                URLQueryItem(name: APIConstants.nameSources, value: APIConstants.valueSources),
                URLQueryItem(name: APIConstants.nameKey, value: APIConstants.valueKey)
            ]

        guard let url = urlComponents.url else { return }
        
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n NetworkManager: makeJSONNewsRequest: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response as? HTTPURLResponse {
                if strongResponse.statusCode != 200 {
                    print("\n", strongResponse.debugDescription)
                }
            }
            if let data = data {
                DispatchQueue.main.async {
                let news = try? JSONDecoder().decode(JSONResponseNewsModel.self, from: data)
                    completion(news)
                }
            } else {
                print("\n NetworkManager: makeJSONNewsRequest no data.")
            }
        }
        dataTask?.resume()
    }

    func makeNewsRequestByLink(url: URL, completion: @escaping ((title: String, body: String)?) -> Void) {
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n NetworkManager: makeNewsRequestByLink: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response as? HTTPURLResponse {
                if strongResponse.statusCode != 200 {
                    print("\n", strongResponse.debugDescription)
                }
            }

            if let data = data, let htmlString = String(data: data, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async {
                    let result = NetworkManager.parseHTML(htmlString: htmlString)
                    completion(result)
                }
            } else {
                print("\n NetworkManager: makeXMLNewsRequest no data.")
            }
        }
        dataTask?.resume()
    }

    static private func parseHTML(htmlString: String) -> (String, String)? {
        do {
            var result = (title: "", body: "")
            let doc: Document = try SwiftSoup.parse(htmlString)

            let title = try doc.getElementsByClass("headline").text()
            result.title = title

            let body = try doc.getElementsByClass("b_article-text").text()
            result.body = body

            if title.isEmpty { return nil }
            
            return result

        } catch {
            print("\n NetworkManager: parseHTML: error")
        }
        return nil
    }
}
