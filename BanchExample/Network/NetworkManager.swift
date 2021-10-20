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

    func makeGazetaRuXMLNewsRequest(completion: @escaping (NewsArray?) -> Void) {
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

    func makeBBCJSONNewsRequest(completion: @escaping (NewsArray?) -> Void) {

        guard var urlComponents = URLComponents(string: BBCAPIConstants.baseURL) else { return }

        urlComponents.queryItems =
            [
                URLQueryItem(name: BBCAPIConstants.nameSources, value: BBCAPIConstants.valueSources),
                URLQueryItem(name: BBCAPIConstants.nameKey, value: BBCAPIConstants.valueKey)
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
                    if let news = try? JSONDecoder().decode(JSONResponseNewsModel.self, from: data) {
                        let newsArray = NewsArray()
                        newsArray.append(array: news)
                        completion(newsArray)
                    } else {
                        completion(nil)
                    }
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
                    let result = htmlString.parseGazetaRuHTML()
                    completion(result)
                }
            } else {
                print("\n NetworkManager: makeNewsRequestByLink no data.")
            }
        }
        dataTask?.resume()
    }
}
